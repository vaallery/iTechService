class AddCaseColorIdToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :case_color_id, :integer
    add_index :devices, :case_color_id
  end
end
