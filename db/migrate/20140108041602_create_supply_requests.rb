class CreateSupplyRequests < ActiveRecord::Migration
  def change
    create_table :supply_requests do |t|
      t.references :user
      t.string :status
      t.string :object
      t.text :description

      t.timestamps
    end
    add_index :supply_requests, :user_id
    add_index :supply_requests, :status
  end
end
