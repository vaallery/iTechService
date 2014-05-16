class AddDepartmentIdToTasks < ActiveRecord::Migration
  class Task < ActiveRecord::Base; end
  def up
    add_column :tasks, :department_id, :string
    add_index :tasks, :department_id

    Task.unscoped.all.each do |r|
      r.update_column :department_id, Department.current.uid
    end
  end

  def down
    remove_index :tasks, :department_id
    remove_column :tasks, :department_id
  end
end
