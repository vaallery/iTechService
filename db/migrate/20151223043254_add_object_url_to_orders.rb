class AddObjectUrlToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :object_url, :string
  end
end
