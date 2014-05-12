class AddDepartmentIdToUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base; end
  def up
    add_column :users, :department_id, :integer
    add_index :users, :department_id

    User.unscoped.all.each do |r|
      r.update_column :department_id, Department.current.id
    end
  end

  def down
    remove_index :users, :department_id
    remove_column :users, :department_id
  end
end
