class CashShiftPolicy < BasePolicy
  def close?
    manage?
  end
end
