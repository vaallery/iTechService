class AddFullPhoneNumberToClients < ActiveRecord::Migration
  def change
    add_column :clients, :full_phone_number, :string
  end
end
