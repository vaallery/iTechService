class AddDepartmentIdToSubstitutePhones < ActiveRecord::Migration
  def change
    add_reference :substitute_phones, :department, index: true, foreign_key: true
  end
end
