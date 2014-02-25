class CreateCashShifts < ActiveRecord::Migration
  def change
    create_table :cash_shifts do |t|
      t.boolean :is_closed, default: false
      t.references :user

      t.timestamps
    end
    add_index :cash_shifts, :user_id
  end
end
