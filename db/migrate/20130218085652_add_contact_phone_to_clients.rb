class AddContactPhoneToClients < ActiveRecord::Migration
  def change
    add_column :clients, :contact_phone, :string
  end
end
