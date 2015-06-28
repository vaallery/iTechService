class AddCarrierToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :carrier_id, :integer
    add_index :devices, :carrier_id
  end
end
