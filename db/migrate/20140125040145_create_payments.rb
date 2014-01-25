class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :payment_type
      t.decimal :value
      t.references :bank

      t.timestamps
    end
    add_index :payments, :payment_type_id
    add_index :payments, :bank_id
  end
end
