class AddCashShiftToSales < ActiveRecord::Migration
  def change
    add_column :sales, :cash_shift_id, :integer
    add_index :sales, :cash_shift_id
  end
end
