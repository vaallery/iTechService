class CreateRepairParts < ActiveRecord::Migration
  def change
    create_table :repair_parts do |t|
      t.references :repair_task
      t.references :item
      t.integer :quantity
      t.integer :warranty_term
      t.integer :defect_qty

      t.timestamps
    end
    add_index :repair_parts, :repair_task_id
    add_index :repair_parts, :item_id
  end
end
