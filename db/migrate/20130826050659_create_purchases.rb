class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :contractor
      t.references :store
      t.integer :status

      t.timestamps
    end
    add_index :purchases, :contractor_id
    add_index :purchases, :store_id
    add_index :purchases, :status
  end
end
