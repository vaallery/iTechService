class AddItemToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :item_id, :integer
    add_index :devices, :item_id
  end
end
