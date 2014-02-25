class AddClientInfoToRepairServices < ActiveRecord::Migration
  def change
    add_column :repair_services, :client_info, :text
  end
end
