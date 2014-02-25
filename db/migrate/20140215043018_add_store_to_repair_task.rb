class AddStoreToRepairTask < ActiveRecord::Migration
  def change
    add_column :repair_tasks, :store_id, :integer
    add_index :repair_tasks, :store_id
  end
end
