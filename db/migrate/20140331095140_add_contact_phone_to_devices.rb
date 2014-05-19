class AddContactPhoneToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :contact_phone, :string
  end
end
