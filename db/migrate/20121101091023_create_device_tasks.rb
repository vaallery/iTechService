class CreateDevicesTasks < ActiveRecord::Migration
  def change
    create_table :devices_tasks do |t|
      t.references :device
      t.references :task
      t.boolean :done
      t.text :comment

      t.timestamps
    end
    add_index :devices_tasks, :device_id
    add_index :devices_tasks, :task_id
  end
end
