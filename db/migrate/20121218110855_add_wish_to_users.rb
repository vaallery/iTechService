class AddWishToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wish, :text
  end
end
