class AddRepairerToRepairTasks < ActiveRecord::Migration
  def change
    add_reference :repair_tasks, :repairer, index: true
    add_foreign_key :repair_tasks, :users, column: :repairer_id
  end
end
