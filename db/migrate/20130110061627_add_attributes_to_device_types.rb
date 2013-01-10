class AddAttributesToDeviceTypes < ActiveRecord::Migration
  def change
    add_column :device_types, :qty_for_replacement, :integer, default: 0
    add_column :device_types, :qty_replaced, :integer, default: 0
  end
end
