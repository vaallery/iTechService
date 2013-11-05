class AddDepthToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :ancestry_depth, :integer, default: 0
  end
end
