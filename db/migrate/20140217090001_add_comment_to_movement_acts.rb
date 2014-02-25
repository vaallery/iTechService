class AddCommentToMovementActs < ActiveRecord::Migration
  def change
    add_column :movement_acts, :comment, :text
  end
end
