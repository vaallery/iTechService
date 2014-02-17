class CreateDepartments < ActiveRecord::Migration
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
  end
end
