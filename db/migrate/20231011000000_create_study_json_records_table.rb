class CreateStudyJsonRecordsTable < ActiveRecord::Migration[7.0]

  def up

    create_table "support.study_json_records", force: :cascade do |t|
      t.string   "nct_id"
      t.json     "content"
      t.datetime "download_date"
      t.timestamps null: false
    end

    add_index "support.study_json_records", :nct_id
    add_index "support.study_json_records", :download_date
  end

  def down
    execute <<-SQL
      DROP TABLE support.study_json_records;
    SQL
  end

end
