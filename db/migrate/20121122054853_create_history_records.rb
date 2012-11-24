class CreateHistoryRecords < ActiveRecord::Migration
  def change
    create_table :history_records do |t|
      t.references :user
      t.references :object, polymorphic: true
      t.string :column_name
      t.string :column_type
      t.string :old_value
      t.string :new_value
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :history_records, :user_id
    add_index :history_records, [:object_id, :object_type]
    
    add_index :history_records, :old_value
    add_index :history_records, :new_value
    add_index :history_records, [:old_value, :new_value]
  end
end