class AddIsClosedToInstallmentPlans < ActiveRecord::Migration
  def change
    add_column :installment_plans, :is_closed, :boolean, default: false
    add_index :installment_plans, :is_closed
  end
end
