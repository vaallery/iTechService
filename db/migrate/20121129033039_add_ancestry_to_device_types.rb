class AddAncestryToDeviceTypes < ActiveRecord::Migration
  def change
    add_column :device_types, :ancestry, :string
    add_index :device_types, :ancestry
  end
end
