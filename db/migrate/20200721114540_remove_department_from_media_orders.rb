class RemoveDepartmentFromMediaOrders < ActiveRecord::Migration
  def change
    remove_column :media_orders, :department_id
  end
end
