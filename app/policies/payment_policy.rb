class PaymentPolicy < BasePolicy
  def create?
    any_manager?(:software, :universal)
  end
end
