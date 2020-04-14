class PricePolicy < BasePolicy
  def create?
    any_manager?(:marketing)
  end

  def update?
    superadmin? || (same_department? && any_manager?(:marketing))
  end

  def destroy?
    superadmin? || (same_department? && any_manager?(:marketing))
  end
end
