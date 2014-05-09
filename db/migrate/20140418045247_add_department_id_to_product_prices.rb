class AddDepartmentIdToProductPrices < ActiveRecord::Migration
  class ProductPrice < ActiveRecord::Base; end

  def change
    add_column :product_prices, :department_id, :integer
    add_index :product_prices, :department_id

    ProductPrice.unscoped.all.each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
