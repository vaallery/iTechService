class CreateServiceJobSubscriptions < ActiveRecord::Migration
  def change
    create_table :service_job_subscriptions, id: false do |t|
      t.references :service_job, null: false, index: true
      t.references :subscriber, null: false, index: true
    end
    add_index :service_job_subscriptions, [:service_job_id, :subscriber_id], unique: true, name: 'index_service_job_subscriptions'
  end
end
