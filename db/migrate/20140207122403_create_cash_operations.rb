class CreateCashOperations < ActiveRecord::Migration
  def change
    create_table :cash_operations do |t|
      t.references :cash_shift
      t.references :user
      t.boolean :is_out, default: false
      t.decimal :value

      t.timestamps
    end
    add_index :cash_operations, :cash_shift_id
    add_index :cash_operations, :user_id
  end
end
