class AddIndexes < ActiveRecord::Migration
  def change
    add_index :device_tasks, :done
    add_index :device_tasks, :done_at
    add_index :device_types, :name
    add_index :devices, :done_at
    add_index :history_records, :column_name
    add_index :locations, :name
    add_index :tasks, :name
    add_index :tasks, :role
    add_index :users, :name
    add_index :users, :surname
    add_index :users, :patronymic
    add_index :orders, [:customer_id, :customer_type]
    add_index :clients, :surname
    add_index :clients, :name
    add_index :clients, :patronymic
    add_index :clients, :phone_number
    add_index :clients, :card_number
    add_index :clients, :email
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
