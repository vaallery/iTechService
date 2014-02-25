class AddSaleIdToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :sale_id, :integer
    add_index :devices, :sale_id
  end
end
