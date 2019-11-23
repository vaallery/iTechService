class AddSaleAmountToTradeInDevice < ActiveRecord::Migration
  def change
    add_column :trade_in_devices, :sale_amount, :integer
  end
end
