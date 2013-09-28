class CreateSaleItems < ActiveRecord::Migration
  def change
    create_table :sale_items do |t|
      t.references :sale
      t.references :item
      t.decimal :price, precision: 8, scale: 2
      t.integer :quantity

      t.timestamps
    end
    add_index :sale_items, :sale_id
    add_index :sale_items, :item_id
  end
end
