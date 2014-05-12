class AddDepartmentIdToClients < ActiveRecord::Migration
  class Client < ActiveRecord::Base; end
  def up
    add_column :clients, :department_id, :integer
    add_index :clients, :department_id

    Client.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end

  def down
    remove_index :clients, :department_id
    remove_column :clients, :department_id
  end
end
