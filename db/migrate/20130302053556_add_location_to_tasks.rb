class AddLocationToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :location_id, :integer
    add_index :tasks, :location_id
  end
end
