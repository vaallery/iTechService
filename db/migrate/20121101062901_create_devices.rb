class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references :device_type
      t.string :ticket_number
      t.references :client
      t.text :comment

      t.timestamps
    end
    add_index :devices, :device_type_id
    add_index :devices, :client_id
  end
end
