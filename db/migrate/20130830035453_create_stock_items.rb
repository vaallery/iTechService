class CreateStockItems < ActiveRecord::Migration
  def change
    create_table :stock_items do |t|
      t.references :item, polymorphic: true
      t.references :store
      t.integer :quantity

      t.timestamps
    end
    add_index :stock_items, :store_id
    add_index :stock_items, [:item_id, :item_type]
  end
end
