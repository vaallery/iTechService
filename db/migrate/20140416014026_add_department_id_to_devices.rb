class AddDepartmentIdToDevices < ActiveRecord::Migration
  class Device < ActiveRecord::Base; end

  def up
    add_column :devices, :department_id, :integer
    add_index :devices, :department_id

    Device.unscoped.find_each do |device|
      device.update_column :department_id, Department.current.try(:id)
    end
  end

  def down
    remove_index :devices, :department_id
    remove_column :devices, :department_id
  end
end
