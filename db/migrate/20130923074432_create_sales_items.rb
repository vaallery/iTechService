class CreateSalesItems < ActiveRecord::Migration
  def change
    create_table :sales_items, id: false do |t|
      t.references :sale
      t.references :item
    end
    add_index :sales_items, :sale_id
    add_index :sales_items, :item_id
  end
end
