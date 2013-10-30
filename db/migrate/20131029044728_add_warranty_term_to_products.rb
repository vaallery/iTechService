class AddWarrantyTermToProducts < ActiveRecord::Migration
  def change
    add_column :products, :warranty_term, :integer
  end
end
