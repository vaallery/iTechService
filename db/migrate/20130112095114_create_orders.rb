class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.references :customer, polymorphic: true
      t.string :object_kind
      t.string :object
      t.date :desired_date
      t.string :status
      t.text :comment

      t.timestamps
    end

    add_index :orders, :customer_id
    add_index :orders, :object_kind
    add_index :orders, :status
  end
end
