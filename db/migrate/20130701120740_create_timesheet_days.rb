class CreateTimesheetDays < ActiveRecord::Migration
  def change
    create_table :timesheet_days do |t|
      t.date :date
      t.references :user
      t.string :status
      t.integer :work_mins
      t.time :appearance

      t.timestamps
    end
    add_index :timesheet_days, :date
    add_index :timesheet_days, :user_id
    add_index :timesheet_days, :status
  end
end
