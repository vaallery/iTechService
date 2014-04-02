class AddDepartmentIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :department_id, :integer
    add_index :settings, :department_id
  end
end
