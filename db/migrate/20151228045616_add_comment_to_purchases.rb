class AddCommentToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :comment, :text
  end
end
