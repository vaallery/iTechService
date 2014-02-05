class AddClosedAtToCashShifts < ActiveRecord::Migration
  def change
    add_column :cash_shifts, :closed_at, :datetime
  end
end
