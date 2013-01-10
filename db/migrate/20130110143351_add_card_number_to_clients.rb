class AddCardNumberToClients < ActiveRecord::Migration
  def change
    add_column :clients, :card_number, :string
  end
end
