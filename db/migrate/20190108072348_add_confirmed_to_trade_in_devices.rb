class AddConfirmedToTradeInDevices < ActiveRecord::Migration
  class TradeInDevice < ActiveRecord::Base; end

  def change
    add_column :trade_in_devices, :confirmed, :boolean, index: true

    reversible do |dir|
      dir.up do
        TradeInDevice.where(confirmed: nil).find_each do |device|
          device.update_column(:confirmed, true)
        end

        change_column_null :trade_in_devices, :confirmed, false
        change_column_default :trade_in_devices, :confirmed, false
      end
    end
  end
end
