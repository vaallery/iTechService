class AddPictureToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :picture, :string
  end
end
