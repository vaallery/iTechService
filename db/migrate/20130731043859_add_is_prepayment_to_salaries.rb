class AddIsPrepaymentToSalaries < ActiveRecord::Migration
  def change
    add_column :salaries, :is_prepayment, :boolean
    add_index :salaries, :is_prepayment
  end
end
