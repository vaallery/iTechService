class AddTypeOfWorkToServiceJobs < ActiveRecord::Migration
  def change
    add_column :service_jobs, :type_of_work, :string
  end
end
