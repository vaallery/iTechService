class AddCodeToServiceFreeTasks < ActiveRecord::Migration
  def change
    add_column :service_free_tasks, :code, :string, index: true
  end
end
