class AddScheduleToUser < ActiveRecord::Migration
  def change
    add_column :users, :schedule, :boolean
    add_index :users, :schedule
  end
end
