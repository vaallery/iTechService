class TradeInDevice::Policy < BasePolicy
  def index?
    user.present?
  end

  def show?
    user.any_admin?
  end

  def print?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.any_admin?
  end

  def destroy?
    user.superadmin?
  end
end
