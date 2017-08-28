class AddIpNetworkToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :ip_network, :string
  end
end
