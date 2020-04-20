class AddCompletenessToServiceJobs < ActiveRecord::Migration
  def change
    add_column :service_jobs, :completeness, :string
  end
end
