class AddCashDrawerIdToCashShifts < ActiveRecord::Migration
  def change
    add_column :cash_shifts, :cash_drawer_id, :integer
    add_index :cash_shifts, :cash_drawer_id
  end
end
