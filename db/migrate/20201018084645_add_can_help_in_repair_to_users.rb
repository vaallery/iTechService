class AddCanHelpInRepairToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_help_in_repair, :boolean, default: false
  end
end
