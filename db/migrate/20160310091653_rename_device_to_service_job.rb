class RenameDeviceToServiceJob < ActiveRecord::Migration
  def change
    rename_table :devices, :service_jobs
    rename_column :device_tasks, :device_id, :service_job_id
    rename_column :device_notes, :device_id, :service_job_id
  end
end
