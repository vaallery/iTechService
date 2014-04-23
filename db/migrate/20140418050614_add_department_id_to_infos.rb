class AddDepartmentIdToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :department_id, :integer
    add_index :infos, :department_id
  end
end
