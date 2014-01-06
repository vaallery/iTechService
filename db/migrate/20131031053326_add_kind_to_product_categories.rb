class AddKindToProductCategories < ActiveRecord::Migration
  def change
    add_column :product_categories, :kind, :string
    add_index :product_categories, :kind
  end
end
