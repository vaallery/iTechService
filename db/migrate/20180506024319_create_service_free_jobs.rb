class CreateServiceFreeJobs < ActiveRecord::Migration
  def change
    create_table :service_free_jobs do |t|
      t.references :performer, null: false, index: true
      t.references :client, null: false, index: true, foreign_key: true
      t.references :task, null: false, index: true
      t.text :comment
      t.datetime :performed_at, null: false

      t.timestamps null: false
    end
    add_foreign_key :service_free_jobs, :users, column: :performer_id
    add_foreign_key :service_free_jobs, :service_free_tasks, column: :task_id
  end
end
