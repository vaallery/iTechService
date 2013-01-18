class AddFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :surname, :string
    add_column :clients, :patronymic, :string
    add_column :clients, :birthday, :date
    add_column :clients, :email, :string
    add_column :clients, :admin_info, :text
  end
end
