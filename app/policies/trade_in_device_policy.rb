class TradeInDevicePolicy < BasePolicy
  def manage?
    superadmin? || able_to?(:manage_trade_in)
  end

  def create?; true; end

  def index?; true; end

  def show?; true; end

  def print?; true; end

  def index_unconfirmed?
    manage?
  end
end
