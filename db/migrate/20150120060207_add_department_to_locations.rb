class AddDepartmentToLocations < ActiveRecord::Migration
  class Location < ActiveRecord::Base; end
  def up
    add_column :locations, :department_id, :integer
    add_index :locations, :department_id

    Location.unscoped.find_each { |r| r.update_column(:department_id, Department.current.id) }
  end

  def down
    remove_column :locations, :department_id
    remove_index :locations, :department_id
  end
end
