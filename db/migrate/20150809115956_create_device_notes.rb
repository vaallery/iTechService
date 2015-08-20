class CreateDeviceNotes < ActiveRecord::Migration
  def change
    create_table :device_notes do |t|
      t.references :device, null: false
      t.references :user, null: false
      t.text :content, null: false

      t.timestamps
    end
    add_index :device_notes, :device_id
    add_index :device_notes, :user_id
  end
end
