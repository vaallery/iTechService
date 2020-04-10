class InstallmentPlanPolicy < BasePolicy
  def read?
    (same_department? && any_manager?) || (record.user == user)
  end
end
