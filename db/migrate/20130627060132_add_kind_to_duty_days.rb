class AddKindToDutyDays < ActiveRecord::Migration
  def change
    add_column :duty_days, :kind, :string
    add_index :duty_days, :kind
    DutyDay.reset_column_information
    DutyDay.find_each do |duty_day|
      duty_day.update_attribute :kind, 'kitchen'
    end
  end
end
