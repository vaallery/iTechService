class AddBrandToDepartment < ActiveRecord::Migration
  def change
    add_reference :departments, :brand, index: true, foreign_key: true
  end
end
