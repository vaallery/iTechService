class AddKeeperToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :keeper_id, :integer
  end
end
