class AddSessionDurationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :session_duration, :integer
  end
end
