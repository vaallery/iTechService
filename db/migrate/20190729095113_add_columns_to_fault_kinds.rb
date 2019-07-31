class AddColumnsToFaultKinds < ActiveRecord::Migration
  def change
    add_column :fault_kinds, :description, :text
    add_column :fault_kinds, :financial, :boolean, null: false, default: false
    add_column :fault_kinds, :penalties, :string
  end
end
