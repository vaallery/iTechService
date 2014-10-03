class AddPriorityToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :priority, :integer, default: 1
    add_index :orders, :priority
  end
end
