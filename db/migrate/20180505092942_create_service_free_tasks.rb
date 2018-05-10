class CreateServiceFreeTasks < ActiveRecord::Migration
  def change
    create_table :service_free_tasks do |t|
      t.string :name, null: false
      t.string :icon

      t.timestamps null: false
    end
  end
end
