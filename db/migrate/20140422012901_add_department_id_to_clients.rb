class AddDepartmentIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :department_id, :integer
    add_index :clients, :department_id
  end
end
