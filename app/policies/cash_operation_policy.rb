class CashOperationPolicy < BasePolicy
  def manage?; any_manager?; end

  def create?
    any_manager?(:software)
  end

  def update?
    same_department? && manage?
  end

  def destroy?
    same_department? && manage?
  end
end
