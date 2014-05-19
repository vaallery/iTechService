class AddDepartmentIdToQuickOrders < ActiveRecord::Migration
  class QuickOrder < ActiveRecord::Base; end
  def change
    add_column :quick_orders, :department_id, :integer
    add_index :quick_orders, :department_id

    QuickOrder.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
