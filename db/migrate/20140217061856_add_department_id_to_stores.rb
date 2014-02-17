class AddDepartmentIdToStores < ActiveRecord::Migration
  def change
    add_column :stores, :department_id, :integer
    add_index :stores, :department_id
  end
end
