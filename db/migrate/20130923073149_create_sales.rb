class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :store
      t.references :user
      t.references :client
      t.references :payment_type
      t.datetime :date
      t.integer :status

      t.timestamps
    end
    add_index :sales, :store_id
    add_index :sales, :user_id
    add_index :sales, :client_id
    add_index :sales, :payment_type_id
    add_index :sales, :status
  end
end
