class AddDepartmentIdToProductPrices < ActiveRecord::Migration
  def change
    add_column :product_prices, :department_id, :integer
    add_index :product_prices, :department_id
  end
end
