class AddUserAndUserCommentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :user_id, :integer
    add_column :orders, :user_comment, :text
    add_index :orders, :user_id
  end
end
