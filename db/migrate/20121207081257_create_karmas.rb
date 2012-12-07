class CreateKarmas < ActiveRecord::Migration
  def change
    create_table :karmas do |t|
      t.boolean :good
      t.text :comment
      t.references :user

      t.timestamps
    end
    add_index :karmas, :user_id
  end
end
