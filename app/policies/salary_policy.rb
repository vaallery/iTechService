class SalaryPolicy < BasePolicy
  def index?; manage?; end

  def create?; manage?; end

  def show?
    same_department? && manage?
  end

  def update?
    same_department? && manage?
  end

  def destroy?
    same_department? && manage?
  end

  def manage?
    superadmin? || able_to?(:manage_salary)
  end
end
