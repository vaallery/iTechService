class AddDepartmentIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :department_id, :integer
    add_index :clients, :department_id

    Client.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
