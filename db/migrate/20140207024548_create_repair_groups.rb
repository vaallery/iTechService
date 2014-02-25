class CreateRepairGroups < ActiveRecord::Migration
  def change
    create_table :repair_groups do |t|
      t.string :name
      t.string :ancestry
      t.integer :ancestry_depth, default: 0

      t.timestamps
    end
    add_index :repair_groups, :ancestry
  end
end
