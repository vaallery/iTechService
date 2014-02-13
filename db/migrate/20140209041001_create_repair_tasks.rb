class CreateRepairTasks < ActiveRecord::Migration
  def change
    create_table :repair_tasks do |t|
      t.references :repair_service
      t.references :device_task
      t.decimal :price

      t.timestamps
    end
    add_index :repair_tasks, :repair_service_id
    add_index :repair_tasks, :device_task_id
  end
end
