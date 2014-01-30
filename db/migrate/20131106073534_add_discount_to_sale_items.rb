class AddDiscountToSaleItems < ActiveRecord::Migration
  def change
    add_column :sale_items, :discount, :decimal, default: 0
  end
end
