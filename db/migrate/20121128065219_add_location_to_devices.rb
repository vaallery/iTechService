class AddLocationToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :location_id, :integer
    add_index :devices, :location_id
  end
end
