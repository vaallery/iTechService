class AddDepartmentIdToDeviceTypes < ActiveRecord::Migration
  class DeviceType < ActiveRecord::Base; end
  def up
    add_column :device_types, :department_id, :string
    add_index :device_types, :department_id

    DeviceType.unscoped.all.each do |r|
      r.update_column :department_id, Department.current.uid
    end
  end

  def down
    remove_index :device_types, :department_id
    remove_column :device_types, :department_id
  end
end
