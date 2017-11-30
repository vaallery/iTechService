class FaultKind::Policy < BasePolicy
  def index?
    user.any_admin?
  end

  def create?
    user.any_admin?
  end

  def update?
    user.any_admin?
  end

  def destroy?
    user.any_admin?
  end
end
