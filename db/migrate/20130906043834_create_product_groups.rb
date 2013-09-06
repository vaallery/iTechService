class CreateProductGroups < ActiveRecord::Migration
  def change
    create_table :product_groups do |t|
      t.string :name
      t.string :ancestry
      t.references :product_category

      t.timestamps
    end
    add_index :product_groups, :ancestry
    add_index :product_groups, :product_category_id
  end
end
