class PricePolicy < BasePolicy
  def create?
    any_manager?(:marketing)
  end

  def update?
    same_department? && any_manager?(:marketing)
  end

  def destroy?
    same_department? && any_manager?(:marketing)
  end
end
