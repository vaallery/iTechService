class AddReturnAtToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :return_at, :datetime
  end
end
