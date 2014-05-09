class AddDepartmentIdToPrices < ActiveRecord::Migration
  class Price < ActiveRecord::Base; end
  def change
    add_column :prices, :department_id, :integer
    add_index :prices, :department_id

    Price.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
