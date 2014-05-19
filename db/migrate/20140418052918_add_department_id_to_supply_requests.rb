class AddDepartmentIdToSupplyRequests < ActiveRecord::Migration
  class SupplyRequest < ActiveRecord::Base; end

  def change
    add_column :supply_requests, :department_id, :integer
    add_index :supply_requests, :department_id

    SupplyRequest.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
