class AddUserCommentToDeviceTasks < ActiveRecord::Migration
  def change
    add_column :device_tasks, :user_comment, :text
  end
end
