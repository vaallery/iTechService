class AddDepartmentIdToQuickOrders < ActiveRecord::Migration
  def change
    add_column :quick_orders, :department_id, :integer
    add_index :quick_orders, :department_id
  end
end
