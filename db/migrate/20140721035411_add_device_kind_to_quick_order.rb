class AddDeviceKindToQuickOrder < ActiveRecord::Migration
  def change
    add_column :quick_orders, :device_kind, :string
  end
end
