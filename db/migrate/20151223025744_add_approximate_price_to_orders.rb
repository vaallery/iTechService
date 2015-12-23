class AddApproximatePriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :approximate_price, :decimal
  end
end
