class AddIsTrayPresentToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :is_tray_present, :boolean
  end
end
