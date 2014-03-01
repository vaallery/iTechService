class AddCodeToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :code, :string
    add_index :product_groups, :code
  end
end
