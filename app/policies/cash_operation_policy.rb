class CashOperationPolicy < BasePolicy
  def manage?; any_manager?; end

  def create?
    any_manager?(:software)
  end
end
