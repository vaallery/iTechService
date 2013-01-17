class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :content
      t.string :kind, null: false
      t.references :user, null: false
      t.boolean :active

      t.timestamps
    end
    add_index :announcements, :user_id
    add_index :announcements, :kind
  end
end
