class AddContactPhoneToDevices < ActiveRecord::Migration
  def up
    add_column :devices, :contact_phone, :string unless column_exists?(:devices, :contact_phone)
  end

  def down
    remove_column :devices, :contact_phone
  end
end
