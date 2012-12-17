class CreateDutyDays < ActiveRecord::Migration
  def change
    create_table :duty_days do |t|
      t.references :user
      t.date :day

      t.timestamps
    end
    add_index :duty_days, :user_id
    add_index :duty_days, :day
  end
end
