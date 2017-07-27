class AddWorkOrderFieldsToServiceJob < ActiveRecord::Migration
  def change
    add_column :service_jobs, :client_address, :string
    add_column :service_jobs, :claimed_defect, :text
    add_column :service_jobs, :device_condition, :text
  end
end
