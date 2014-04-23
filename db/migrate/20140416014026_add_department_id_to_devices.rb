class AddDepartmentIdToDevices < ActiveRecord::Migration
  class Device < ActiveRecord::Base
    attr_accessible :department_id
  end

  def change
    add_column :devices, :department_id, :integer
    add_index :devices, :department_id

    Device.unscoped.find_each do |device|
      device.update_attributes! department_id: Department.current.try(:id)
    end
  end
end
