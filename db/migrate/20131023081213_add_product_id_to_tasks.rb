class AddProductIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :product_id, :integer
    add_index :tasks, :product_id
  end
end
