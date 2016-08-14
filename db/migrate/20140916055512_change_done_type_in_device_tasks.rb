class ChangeDoneTypeInDeviceTasks < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE device_tasks ALTER COLUMN done DROP DEFAULT;'
    change_column :device_tasks, :done, 'integer USING CAST(done AS integer)', limit: 1
    execute 'ALTER TABLE device_tasks ALTER COLUMN done SET DEFAULT 0;'
    # change_column_default :device_tasks, :done, 0
  end

  def down
  end
end
