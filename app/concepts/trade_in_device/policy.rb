class TradeInDevice::Policy < BasePolicy
  def index?
    user.present?
  end

  def index_unconfirmed?
    superadmin? || able_to_manage?
  end

  def show?
    any_admin? || able_to_manage?
  end

  def print?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    superadmin? || able_to_manage?
  end

  def destroy?
    superadmin? || able_to_manage?
  end

  private

  def able_to_manage?
    able_to? :manage_trade_in
  end
end
