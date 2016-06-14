class AddDataStoragesToServiceJobs < ActiveRecord::Migration
  def change
    add_column :service_jobs, :data_storages, :string
  end
end
