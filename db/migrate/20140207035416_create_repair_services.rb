class CreateRepairServices < ActiveRecord::Migration
  def change
    create_table :repair_services do |t|
      t.references :repair_group
      t.string :name
      t.decimal :price

      t.timestamps
    end
    add_index :repair_services, :repair_group_id
  end
end
