class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photo, :string
    add_column :users, :surname, :string
    add_column :users, :name, :string
    add_column :users, :patronymic, :string
    add_column :users, :birthday, :date
    add_column :users, :hiring_date, :date
    add_column :users, :salary_date, :date
    add_column :users, :prepayment, :string
  end
end
