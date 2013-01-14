class AddIndexToClients < ActiveRecord::Migration
  def change
    add_index :clients, :full_phone_number
  end
end
