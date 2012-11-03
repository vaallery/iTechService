class CreateDeviceTasks < ActiveRecord::Migration
  def change
    create_table :device_tasks do |t|
      t.references :device
      t.references :task
      t.boolean :done
      t.text :comment

      t.timestamps
    end
    add_index :device_tasks, :device_id
    add_index :device_tasks, :task_id
  end
end
