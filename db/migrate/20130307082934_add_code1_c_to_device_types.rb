class AddCode1CToDeviceTypes < ActiveRecord::Migration
  def change
    add_column :device_types, :code_1c, :integer
    add_index :device_types, :code_1c
  end
end
