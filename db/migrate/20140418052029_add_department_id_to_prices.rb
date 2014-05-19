class AddDepartmentIdToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :department_id, :integer
    add_index :prices, :department_id
  end
end
