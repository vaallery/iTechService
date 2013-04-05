class AddClientNotificationToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :notify_client, :boolean, default: false
    add_column :devices, :client_notified, :boolean, default: false
  end
end
