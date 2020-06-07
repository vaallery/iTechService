class AddClientToTradeInDevices < ActiveRecord::Migration
  def change
    add_reference :trade_in_devices, :client, index: true, foreign_key: true
  end
end
