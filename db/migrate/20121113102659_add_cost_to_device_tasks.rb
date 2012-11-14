class AddCostToDeviceTasks < ActiveRecord::Migration
  def change
    add_column :device_tasks, :cost, :decimal
  end
end
