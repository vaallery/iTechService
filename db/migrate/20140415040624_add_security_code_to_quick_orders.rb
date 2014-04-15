class AddSecurityCodeToQuickOrders < ActiveRecord::Migration
  def change
    add_column :quick_orders, :security_code, :string
  end
end
