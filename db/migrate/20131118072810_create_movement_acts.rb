class CreateMovementActs < ActiveRecord::Migration
  def change
    create_table :movement_acts do |t|
      t.datetime :date
      t.integer :store_id
      t.integer :dst_store_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
    add_index :movement_acts, :store_id
    add_index :movement_acts, :dst_store_id
    add_index :movement_acts, :user_id
  end
end
