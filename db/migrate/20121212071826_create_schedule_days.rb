class CreateScheduleDays < ActiveRecord::Migration
  def change
    create_table :schedule_days do |t|
      t.integer :user_id
      t.integer :day
      t.string :hours

      t.timestamps
    end
    add_index :schedule_days, :user_id
    add_index :schedule_days, :day
  end
end
