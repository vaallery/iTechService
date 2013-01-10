class AddSecurityCodeToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :security_code, :string
  end
end
