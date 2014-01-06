class AddDeviceTypeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :device_type_id, :integer
    add_index :products, :device_type_id
  end
end
