class CreateMovementItems < ActiveRecord::Migration
  def change
    create_table :movement_items do |t|
      t.references :movement_act
      t.references :item
      t.integer :quantity

      t.timestamps
    end
    add_index :movement_items, :movement_act_id
    add_index :movement_items, :item_id
  end
end
