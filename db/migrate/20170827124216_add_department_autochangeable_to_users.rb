class AddDepartmentAutochangeableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :department_autochangeable, :boolean, null: false, default: true
  end
end
