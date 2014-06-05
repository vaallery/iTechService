class CreateImportedSales < ActiveRecord::Migration
  def change
    create_table :imported_sales do |t|
      t.references :device_type
      t.string :imei
      t.string :serial_number
      t.datetime :sold_at
      t.string :quantity

      t.timestamps
    end
    add_index :imported_sales, :device_type_id
  end
end
