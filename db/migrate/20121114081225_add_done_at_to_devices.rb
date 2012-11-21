class AddDoneAtToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :done_at, :datetime, default: nil
  end
end
