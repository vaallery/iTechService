class AddReceiverToServiceFreeJobs < ActiveRecord::Migration
  def change
    add_reference :service_free_jobs, :receiver, index: true#, foreign_key: true
    add_foreign_key :service_free_jobs, :users, column: :receiver_id
  end
end
