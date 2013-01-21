class AddAttributesToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :imei, :string
    add_column :devices, :replaced, :boolean, default: false
  end
end
