class TradeInDevice::Policy < BasePolicy
  def index?
    user.present?
  end

  def show?
    user.superadmin?
  end

  def print?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.superadmin?
  end

  def destroy?
    user.superadmin?
  end
end
