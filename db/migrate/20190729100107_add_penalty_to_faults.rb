class AddPenaltyToFaults < ActiveRecord::Migration
  def change
    add_column :faults, :penalty, :integer
  end
end
