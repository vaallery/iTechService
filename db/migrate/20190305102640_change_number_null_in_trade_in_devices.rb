class ChangeNumberNullInTradeInDevices < ActiveRecord::Migration
  def change
    change_column_null :trade_in_devices, :number, true
  end
end
