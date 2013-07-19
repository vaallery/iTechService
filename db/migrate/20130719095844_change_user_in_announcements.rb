class ChangeUserInAnnouncements < ActiveRecord::Migration
  def up
    change_column_null :announcements, :user_id, true
  end

  def down
  end
end
