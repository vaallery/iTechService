class CreateDepartments < ActiveRecord::Migration
  class Department < ActiveRecord::Base
    attr_accessible :name, :role, :code, :url, :city, :address, :contact_phone, :schedule
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
    Department.where(code: ENV['DEPARTMENT_CODE']).first_or_create(name: ENV['DEPARTMENT_NAME'] || 'Владивосток', role: ENV['DEPARTMENT_ROLE'] || 0, address: '-', contact_phone: '-', schedule: '-', url: '-')
  end
end
