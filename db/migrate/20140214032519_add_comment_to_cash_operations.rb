class AddCommentToCashOperations < ActiveRecord::Migration
  def change
    add_column :cash_operations, :comment, :text
  end
end
