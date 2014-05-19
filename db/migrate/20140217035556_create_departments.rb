class CreateDepartments < ActiveRecord::Migration
  class Department < ActiveRecord::Base
  end

  def change
    create_table :departments do |t|
      t.string :name
      t.string :code
      t.integer :role
      t.string :url
      t.string :city
      t.string :address
      t.string :contact_phone
      t.text :schedule

      t.timestamps
    end
    add_index :departments, :role
    add_index :departments, :code
    Department.where(code: ENV['DEPARTMENT_CODE'] || 'vl').first_or_create(name: ENV['DEPARTMENT_NAME'], role: ENV['DEPARTMENT_ROLE'])
  end
end
