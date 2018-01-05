class AddDifficultToRepairServices < ActiveRecord::Migration
  def change
    add_column :repair_services, :difficult, :boolean, default: false
  end
end
