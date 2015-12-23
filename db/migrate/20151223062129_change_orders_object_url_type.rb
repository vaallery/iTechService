class ChangeOrdersObjectUrlType < ActiveRecord::Migration
  def change
    change_column :orders, :object_url, :text
  end
end
