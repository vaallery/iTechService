class AddDepartmentIdToSupplyRequests < ActiveRecord::Migration
  def change
    add_column :supply_requests, :department_id, :integer
    add_index :supply_requests, :department_id
  end
end
