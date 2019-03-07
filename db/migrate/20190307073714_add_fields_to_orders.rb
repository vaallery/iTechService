class AddFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :model, :text
    add_column :orders, :prepayment, :integer
    add_column :orders, :payment_method, :integer
  end
end
