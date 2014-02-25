class AddRequestPriceToProductCategories < ActiveRecord::Migration
  def change
    add_column :product_categories, :request_price, :boolean
  end
end
