class AddStatusToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :status, :string
    add_index :devices, :status
  end
end
