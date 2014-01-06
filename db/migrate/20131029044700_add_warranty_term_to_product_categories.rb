class AddWarrantyTermToProductCategories < ActiveRecord::Migration
  def change
    add_column :product_categories, :warranty_term, :integer
  end
end
