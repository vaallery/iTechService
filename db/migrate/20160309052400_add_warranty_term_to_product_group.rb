class AddWarrantyTermToProductGroup < ActiveRecord::Migration
  def change
    add_column :product_groups, :warranty_term, :integer, null: false, default: 0
  end
end
