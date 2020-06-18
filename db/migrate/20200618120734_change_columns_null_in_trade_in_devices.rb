class ChangeColumnsNullInTradeInDevices < ActiveRecord::Migration
  def change
    change_column_null :trade_in_devices, :client_name, true
    change_column_null :trade_in_devices, :client_phone, true
  end
end
