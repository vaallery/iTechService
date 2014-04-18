class AddDepartmentIdToSupplyReports < ActiveRecord::Migration
  def change
    add_column :supply_reports, :department_id, :integer
    add_index :supply_reports, :department_id
  end
end
