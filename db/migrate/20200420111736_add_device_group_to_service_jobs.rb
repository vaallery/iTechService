class AddDeviceGroupToServiceJobs < ActiveRecord::Migration
  def change
    add_column :service_jobs, :device_group, :string
  end
end
