class AddDoneAtToDeviceTasks < ActiveRecord::Migration
  def change
    add_column :device_tasks, :done_at, :datetime, default: nil
  end
end
