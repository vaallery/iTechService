class CreateAnnouncementsUsers < ActiveRecord::Migration
  def change
    create_table :announcements_users do |t|
      t.belongs_to :announcement
      t.belongs_to :user
    end
  end
end
