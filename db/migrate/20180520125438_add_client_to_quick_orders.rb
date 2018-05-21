class AddClientToQuickOrders < ActiveRecord::Migration
  def change
    add_reference :quick_orders, :client, index: true, foreign_key: true
  end
end
