class ChangeHistoryRecordValues < ActiveRecord::Migration
  def up
    remove_column :history_records, :old_value
    remove_column :history_records, :new_value
    add_column :history_records, :old_value, :text
    add_column :history_records, :new_value, :text
  end

  def down
  end
end
