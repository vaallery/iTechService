class AddAppStorePasswordToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :app_store_pass, :string
  end
end
