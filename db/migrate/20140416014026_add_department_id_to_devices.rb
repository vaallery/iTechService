class AddDepartmentIdToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :department_id, :integer
    add_index :devices, :department_id

    Device.unscoped.find_each do |device|
      device.update_column :department_id, Department.current.try(:id)
    end
  end
end
