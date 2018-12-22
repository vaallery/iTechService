class AddAppleGuaranteeToTradeInDevices < ActiveRecord::Migration
  def change
    add_column :trade_in_devices, :apple_guarantee, :date, index: true
  end
end
