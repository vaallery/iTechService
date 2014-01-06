class CreateStoreItems < ActiveRecord::Migration
  def change
    create_table :store_items do |t|
      t.references :item
      t.references :store
      t.integer :quantity, default: 0

      t.timestamps
    end
    add_index :store_items, :store_id
    add_index :store_items, :item_id
  end
end
