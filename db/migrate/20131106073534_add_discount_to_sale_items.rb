class AddDiscountToSaleItems < ActiveRecord::Migration
  def change
    add_column :sale_items, :discount, :integer, default: 0
  end
end
