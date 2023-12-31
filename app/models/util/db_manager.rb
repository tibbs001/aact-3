# frozen_string_literal: true

require 'open3'
module Util
  class DbManager
    attr_accessor :con, :public_con, :public_alt_con, :event, :migration_object, :fm

    def initialize(params={})
      # 'event' keeps track of what happened during a single load event & then saves to LoadEvent table in the admin db, so we have a log
      # of all load events that have occurred.  If an event is passed in, use it; otherwise, create a new one.
      @event = params[:event]
      @fm = Util::FileManager.new
      @config = YAML.safe_load(File.read("#{Rails.root}/config/connections.yml")).deep_symbolize_keys
    end

    ##### connection management #####

    def public_connection
      db = @config[:public]
      return unless db

      connection = PublicBase.establish_connection(db).connection
      connection.schema_search_path = 'ctgov'
      connection
    end

    def staging_connection
      db = @config[:staging]
      return unless db

      connection = PublicBase.establish_connection(db).connection
      connection.schema_search_path = 'ctgov'
      connection
    end

    def connection
      ActiveRecord::Base.connection
    end

    ###### export/import methods ######

    # generate a dump file
    def dump_database
      dump_file_location = fm.pg_dump_file
      FileUtils.rm_f(dump_file_location)
      host = ENV['POSTGRES_HOST'] || 'db'
      port = ENV['POSTGRES_PORT'] || '5432'
      username = ENV['POSTGRES_USERNAME'] || 'postgres'
      database = ENV['DATABASE_NAME'] || 'aact_2'

      cmd = "
        pg_dump -v -h #{host} -p #{port} -U #{username} \
        --clean --no-owner -b -c -C -Fc \
        --exclude-table ar_internal_metadata \
        --exclude-table schema_migrations \
        --exclude-table study_records \
        --schema 'ctgov'  \
        -f #{dump_file_location} \
        #{database} \
      "
      Rails.logger.debug cmd
      run_command_line(cmd)

      dump_file_location
    end

    # Restoring a database
    # 1. prevent new connections and disconnect current connections
    # 2. recreate the ctgov schema in the db
    # 3. restore the db from file
    # 4. verify the study count (permissions are not granted again to prevent bad data from being used)
    # 5. grant connection permissions again
    def restore_database(connection, filename, schema = 'public')
      host = ENV['POSTGRES_HOST'] || 'db'
      port = ENV['POSTGRES_PORT'] || '5432'
      username = ENV['POSTGRES_USERNAME'] || 'postgres'
      password = ENV['POSTGRES_PASSWORD']
      database = ENV['DATABASE_NAME'] || 'aact_2'

      # prevent new connections and drop current connections
      ActiveRecord::Base.connection.execute("ALTER DATABASE #{database} CONNECTION LIMIT 0;")
      ActiveRecord::Base.connection.execute("SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND datname ='#{database}' AND usename <> '#{username}'")

      # recreate schema
      log "  dropping in #{host}:#{port}/#{database} database..."
      begin
        ActiveRecord::Base.connection.execute("DROP SCHEMA #{schema} CASCADE;")
      rescue ActiveRecord::StatementInvalid => e
        log(e.message)
      end
      ActiveRecord::Base.connection.execute("CREATE SCHEMA #{schema};")
      ActiveRecord::Base.connection.execute("GRANT USAGE ON SCHEMA #{schema} TO read_only;")

      # restore database
      log "  restoring to #{host}:#{port}/#{database} database..."
      cmd = "PGPASSWORD=#{password} pg_restore -c -j 5 -v -h #{host} -p #{port} -U #{username}  -d #{database} #{filename}"
      run_restore_command_line(cmd)

      # verify that the database was correctly restored
      log "  verifying #{host}:#{port}/#{database} database..."
      study_count = ActiveRecord::Base.connection.execute('select count(*) from studies;').first['count'].to_i
      if study_count != Study.count
        raise "SOMETHING WENT WRONG! PROBLEM IN PRODUCTION DATABASE: #{host}:#{port}/#{database}.  Study count is #{study_count}. Should be #{Study.count}"
      end

      # allow users to access database again
      ActiveRecord::Base.connection.execute("ALTER DATABASE #{database} CONNECTION LIMIT 200;")
      ActiveRecord::Base.connection.execute("GRANT USAGE ON SCHEMA #{schema} TO read_only;")
      ActiveRecord::Base.connection.execute("GRANT SELECT ON ALL TABLES IN SCHEMA #{schema} TO READ_ONLY;")

      true
    end

    def restore_from_file(path_to_file: "#{Rails.root}/tmp/postgres_data.dmp", database: 'aact')
      Rails.logger.debug 'restoring the database...'
      restore_database(ActiveRecord::Base.connection, path_to_file)
      Rails.logger.debug 'done'
    end

    def restore_from_url(params = {})
      url = params[:url]
      database_name = params[:database_name] || 'aact'
      return unless url

      tries ||= 5
      file_path = "#{Rails.root}/tmp/snapshots"
      FileUtils.rm_rf(file_path)
      FileUtils.mkdir_p file_path
      file_name = "#{file_path}/snapshot.zip"
      file = File.new file_name, 'w'

      Rails.logger.debug 'downloading file...'
      begin
        `curl -o #{file.path} #{url}`
      rescue Errno::ECONNRESET
        if (tries -= 1) > 0
          retry
        end
      end
      Rails.logger.debug 'done'

      file.binmode

      Rails.logger.debug 'extracting postgres_data.dmp...'
      Zip::File.open(file) do |zip_file|
        zip_file.each do |f|
          if f.name == 'postgres_data.dmp'
            fpath = File.join(file_path, f.name)
            zip_file.extract(f, fpath) unless File.exist?(fpath)
          end
        end
      end
      Rails.logger.debug 'done'

      restore_from_file({ path_to_file: "#{file_path}/postgres_data.dmp", database: database_name })

      Rails.logger.debug 'removing temp folder...'
      FileUtils.rm_rf(file_path)
      Rails.logger.debug 'done'
    end

    # process for deploying database to digital ocean
    # 1. try restoring to staging db
    # 2. if successful restore to public db
    def refresh_public_db
      restore_database(public_connection, fm.pg_dump_file)
    end

    def run_command_line(cmd)
      _stdout, stderr, status = Open3.capture3(cmd)
      return unless status.exitstatus != 0

      log stderr
      puts stderr
      #event.add_problem("#{Time.zone.now}: #{stderr}")
      false
    end

    def run_restore_command_line(cmd)
      _stdout, stderr, status = Open3.capture3(cmd)
      return unless status.exitstatus != 0

      # Errors that report a db object doesn't already exist aren't real errors. Ignore those.  Look for real errors.
      real_errors = []
      stderr_array = stderr.split('pg_restore:')
      stderr_array.each { |line| real_errors << line if line.include?('ERROR') && line.exclude?('does not exist') }
      return if real_errors.empty?

      real_errors.each { |e| event.add_problem("#{Time.zone.now}: #{e}") } if event
      real_errors.each { |e| Airbrake.notify(e) }
      false
    end

    ###### Constraint Management ######

    def add_indexes_and_constraints
      add_indexes
      add_constraints
    end

    def remove_indexes_and_constraints
      remove_constraints
      remove_indexes
    end

    def add_indexes
      indexes.each do |index|
        unless migration.index_exists?(index[:table], index[:column])
          migration.add_index(index[:table], index[:column], unique: index[:unique])
        end
      end
    end

    def add_constraints
      foreign_key_constraints.each do |constraint|
        child_table = constraint[:child_table]
        parent_table = constraint[:parent_table]
        child_column = constraint[:child_column]
        parent_column = constraint[:parent_column]
        unless migration.foreign_key_exists?(child_table, parent_table, column: child_column)
          migration.add_foreign_key child_table, parent_table, column: child_column, primary_key: parent_column,
                                                              name: "#{child_table}_#{child_column}_fkey"
        end
      end
    end

    def remove_indexes
      StudyRelationship.study_models.each do |model|
        table_name = model.table_name
        connection.indexes(table_name).each do |index|
          migration.remove_index(index.table, index.columns) unless should_keep_index?(index)
        end
      end
    end

    def remove_constraints
      foreign_key_constraints.each do |constraint|
        table = constraint[:child_table]
        column = constraint[:child_column]
        if connection.foreign_keys(table).map(&:column).include?(column)
          connection.remove_foreign_key(table, column: column)
        end
      end
    end

    def should_keep_index?(index)
      return true if (index.table == 'studies') && (index.columns == ['nct_id'])

      false
    end

    def migration
      @migration ||= ActiveRecord::Migration.new
    end

    ###### Information ######
    def indexes
      models = StudyRelationship.study_models.map do |m|
        { table: m.table_name, column: 'nct_id', unique: one_to_one_related_tables.include?(m.table_name) }
      end
      extra = JSON.parse(File.read('db/indexes.json')).map { |k| { table: k.first, column: k.last } }
      models + extra
    end

    def foreign_key_constraints
      Util::DbManager.foreign_key_constraints
    end

    def self.foreign_key_constraints
      models = StudyRelationship.study_models.map do |m|
        { child_table: m.table_name, parent_table: 'studies', child_column: 'nct_id', parent_column: 'nct_id' }
      end
      extra = JSON.parse(File.read('db/foreign_keys.json')).map(&:deep_symbolize_keys)
      models + extra
    end

    def one_to_one_related_tables
      %w[brief_summaries designs detailed_descriptions eligibilities participant_flows
         calculated_values]
    end

    def accessible?(connection)
      config = connection.instance_variable_get('@config')
      name = config[:database]
      output = connection.execute("select datconnlimit from pg_database where datname='#{name}';")
      limit = output.first['datconnlimit'].to_i
      limit > 0 || limit == -1
    end

    def log(msg)
      Rails.logger.debug { "#{Time.zone.now}: #{msg}" } # log to STDOUT
    end
  end
end
