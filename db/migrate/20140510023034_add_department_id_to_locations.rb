class AddDepartmentIdToLocations < ActiveRecord::Migration
  class Location < ActiveRecord::Base; end
  def up
    add_column :locations, :department_id, :string
    add_index :locations, :department_id

    Location.unscoped.all.each do |r|
      r.update_column :department_id, Department.current.uid
    end
  end

  def down
    remove_index :device_types, :department_id
    remove_column :device_types, :department_id
  end
end
