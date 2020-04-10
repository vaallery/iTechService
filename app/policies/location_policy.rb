class LocationPolicy < BasePolicy
  def create?
    any_admin?
  end

  def manage?
    superadmin?
  end
end
