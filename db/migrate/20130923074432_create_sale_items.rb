class CreateSaleItems < ActiveRecord::Migration
  def change
    create_table :sale_items do |t|
      t.references :sale
      t.references :item
      t.integer :quantity

      t.timestamps
    end
    add_index :sale_items, :sale_id
    add_index :sale_items, :item_id
  end
end
