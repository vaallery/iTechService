class AddPositionToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :position, :integer, null: false, default: 0
  end
end
