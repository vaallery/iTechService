class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, null: false
      t.references :commentable, polymorphic: true, null: false
      t.text :content, null: false

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :commentable_id
  end
end
