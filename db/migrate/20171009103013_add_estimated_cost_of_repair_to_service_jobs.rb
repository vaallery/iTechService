class AddEstimatedCostOfRepairToServiceJobs < ActiveRecord::Migration
  def change
    add_column :service_jobs, :estimated_cost_of_repair, :string
  end
end
