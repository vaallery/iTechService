class AddFieldsToTradeInDevices < ActiveRecord::Migration
  def change
    add_column :trade_in_devices, :condition, :text
    add_column :trade_in_devices, :equipment, :text
  end
end
