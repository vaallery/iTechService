class AddAvailabilityAttributesToDeviceTypes < ActiveRecord::Migration
  def change
    add_column :device_types, :qty_shop, :integer
    add_column :device_types, :qty_store, :integer
    add_column :device_types, :qty_reserve, :integer
    add_column :device_types, :expected_during, :integer
  end
end
