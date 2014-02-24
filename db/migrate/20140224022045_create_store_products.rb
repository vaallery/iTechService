class CreateStoreProducts < ActiveRecord::Migration
  def change
    create_table :store_products do |t|
      t.references :store
      t.references :product
      t.integer :warning_quantity

      t.timestamps
    end
    add_index :store_products, :store_id
    add_index :store_products, :product_id
    add_index :store_products, [:product_id, :store_id]
  end
end
