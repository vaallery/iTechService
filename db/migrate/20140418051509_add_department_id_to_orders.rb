class AddDepartmentIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :department_id, :integer
    add_index :orders, :department_id

    Order.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
