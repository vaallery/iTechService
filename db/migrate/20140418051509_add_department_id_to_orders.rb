class AddDepartmentIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :department_id, :integer
    add_index :orders, :department_id
  end
end
