class AddScheduleToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :schedule, :boolean
    add_index :locations, :schedule
  end
end
