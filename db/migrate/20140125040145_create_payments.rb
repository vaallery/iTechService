class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :kind
      t.decimal :value
      t.references :sale
      t.references :bank
      t.references :gift_certificate
      t.string :device_name
      t.string :device_number
      t.string :client_info
      t.string :appraiser

      t.timestamps
    end
    add_index :payments, :kind
    add_index :payments, :sale_id
    add_index :payments, :bank_id
    add_index :payments, :gift_certificate_id
  end
end
