class CreateQuickOrdersQuickTasks < ActiveRecord::Migration
  def change
    create_table :quick_orders_quick_tasks, id: false do |t|
      t.references :quick_order
      t.references :quick_task
    end
    add_index :quick_orders_quick_tasks, [:quick_order_id, :quick_task_id], name: 'index_quick_orders_tasks'
  end
end
