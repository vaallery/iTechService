class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.belongs_to :purchase
      t.belongs_to :item
      t.decimal :price, precision: 8, scale: 2
      t.integer :quantity

      t.timestamps
    end
    add_index :batches, :purchase_id
    add_index :batches, :item_id
  end
end
