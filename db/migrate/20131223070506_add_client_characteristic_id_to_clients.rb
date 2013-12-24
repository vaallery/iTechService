class AddClientCharacteristicIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :client_characteristic_id, :integer
  end
end
