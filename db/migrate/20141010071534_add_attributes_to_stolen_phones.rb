class AddAttributesToStolenPhones < ActiveRecord::Migration
  def change
    add_column :stolen_phones, :serial_number, :string
    add_column :stolen_phones, :client_id, :integer
    add_column :stolen_phones, :client_comment, :text
    add_index :stolen_phones, :client_id
    add_index :stolen_phones, :serial_number
  end
end
