class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :user
      t.references :client

      t.timestamps
    end
    add_index :sales, :user_id
    add_index :sales, :client_id
  end
end
