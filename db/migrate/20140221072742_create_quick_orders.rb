class CreateQuickOrders < ActiveRecord::Migration
  def change
    create_table :quick_orders do |t|
      t.integer :number
      t.references :user
      t.string :client_name
      t.string :contact_phone
      t.text :comment

      t.timestamps
    end
    add_index :quick_orders, :number
    add_index :quick_orders, :user_id
    add_index :quick_orders, :client_name
    add_index :quick_orders, :contact_phone
  end
end
