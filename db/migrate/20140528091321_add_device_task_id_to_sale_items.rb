class AddDeviceTaskIdToSaleItems < ActiveRecord::Migration
  def change
    add_column :sale_items, :device_task_id, :integer
    add_index :sale_items, :device_task_id
  end
end
