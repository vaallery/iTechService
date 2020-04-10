class TradeInDevicePolicy < BasePolicy
  def manage?
    superadmin? || able_to?(:manage_trade_in)
  end

  def create?; true; end

  def read?
    any_admin? || able_to?(:manage_trade_in)
  end

  def index_unconfirmed?
    manage?
  end
end
