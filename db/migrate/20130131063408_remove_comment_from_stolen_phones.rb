class RemoveCommentFromStolenPhones < ActiveRecord::Migration
  def up
    remove_column :stolen_phones, :comment
  end

  def down
  end
end
