class AddIsFiredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_fired, :boolean
    add_index :users, :is_fired
  end
end
