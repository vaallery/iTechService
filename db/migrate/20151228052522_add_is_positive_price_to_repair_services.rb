class AddIsPositivePriceToRepairServices < ActiveRecord::Migration
  def change
    add_column :repair_services, :is_positive_price, :boolean, default: false
  end
end
