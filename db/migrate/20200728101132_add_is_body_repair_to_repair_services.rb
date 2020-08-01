class AddIsBodyRepairToRepairServices < ActiveRecord::Migration
  def change
    add_column :repair_services, :is_body_repair, :boolean, default: false
  end
end
