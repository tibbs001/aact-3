require 'roo'
require 'csv'

namespace :db do

  task drop: [:environment] do
    aact_db = ENV['DATABASE_NAME'] || 'aact_2'
    if ENV['RAILS_ENV'] == 'test'
      begin
        ActiveRecord::Base.connection.execute('DROP DATABASE aact_2_test');
      rescue
      end
    else
      begin
        ActiveRecord::Base.connection.execute('DROP DATABASE #{aact_db}');
      rescue
      end
    end
  end

  task create: [:environment] do
    superusername = ENV['POSTGRES_USERNAME'] || 'postgres'
    password = ENV['POSTGRES_PASSWORD']
    if ENV['RAILS_ENV'] == 'test'
      aact_db = 'aact_2_test'
      begin
        ActiveRecord::Base.connection.execute('CREATE DATABASE aact_2_test');
      rescue
      end
    else
      aact_db = ENV['DATABASE_NAME'] || 'aact_2'
    end
    Rake::Task["db:create"].invoke
    con=ActiveRecord::Base.connection
    if superusername == 'postgres'
    else
      con.execute("DROP ROLE #{superusername};")
      con.execute("CREATE ROLE #{superusername} LOGIN SUPERUSER PASSWORD '#{password}';")
      con.execute("ALTER ROLE #{superusername} WITH CREATEROLE;")
    end
    con.execute("CREATE SCHEMA IF NOT EXISTS ctgov;")
    con.execute("CREATE SCHEMA IF NOT EXISTS support;")
    con.execute("GRANT ALL ON ALL TABLES IN SCHEMA public TO #{superusername};")
    con.execute("GRANT ALL ON ALL TABLES IN SCHEMA ctgov TO #{superusername};")
    con.execute("GRANT ALL ON ALL TABLES IN SCHEMA support TO #{superusername};")
    con.execute("ALTER ROLE #{superusername} IN DATABASE #{aact_db} SET SEARCH_PATH TO ctgov, support, public, ctgov_beta;")
  end

  task copy_schema: [:environment] do
    aact_db = ENV['DATABASE_NAME'] || 'aact_2'
    superusername = ENV['POSTGRES_USERNAME'] || 'postgres'
    if ENV['RAILS_ENV'] == 'test'
      aact_db = 'aact_2_test'
    else
      aact_db = ENV['DATABASE_NAME'] || 'aact_2'
    end

    connection = "-h #{ENV['POSTGRES_HOST'] || 'db'} -p #{ENV['POSTGRES_PORT'] || '5432'}"
    `pg_dump -U #{superusername} --schema='ctgov' --schema-only #{aact_db} #{connection} | sed 's/ctgov/ctgov_beta/g; s/ctgov_beta_group_code/ctgov_group_code/g' | psql -U #{superusername} -d #{aact_db} #{connection}`
  end

  task :generate_schema_png, [:file_name] => :environment do |t, args|
    Util::DbImageGenerator.new.schema_image(args[:file_name])
  end


end
