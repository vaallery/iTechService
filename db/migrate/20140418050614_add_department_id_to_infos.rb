class AddDepartmentIdToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :department_id, :integer
    add_index :infos, :department_id

    Info.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
