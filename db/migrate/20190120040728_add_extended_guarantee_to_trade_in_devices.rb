class AddExtendedGuaranteeToTradeInDevices < ActiveRecord::Migration
  def change
    add_column :trade_in_devices, :extended_guarantee, :boolean
  end
end
