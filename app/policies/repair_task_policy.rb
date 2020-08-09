class RepairTaskPolicy < BasePolicy
  def change_repairer?
    record.repairer == user || record.repairer.nil?
  end
end
