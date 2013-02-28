class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user
      t.string :content
      t.references :recipient, polymorphic: true

      t.timestamps
    end
    add_index :messages, :user_id
    add_index :messages, :recipient_id
  end
end
