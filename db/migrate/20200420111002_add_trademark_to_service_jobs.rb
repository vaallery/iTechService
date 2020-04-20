class AddTrademarkToServiceJobs < ActiveRecord::Migration
  def change
    add_column :service_jobs, :trademark, :string
  end
end
