class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :device_type
      t.string :imei
      t.string :serial_number
      t.datetime :sold_at

      t.timestamps
    end
    add_index :sales, :device_type_id
    add_index :sales, :imei
    add_index :sales, :serial_number
  end
end
