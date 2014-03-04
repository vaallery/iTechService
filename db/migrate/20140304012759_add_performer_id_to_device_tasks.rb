class AddPerformerIdToDeviceTasks < ActiveRecord::Migration
  def change
    add_column :device_tasks, :performer_id, :integer
    add_index :device_tasks, :performer_id
  end
end
