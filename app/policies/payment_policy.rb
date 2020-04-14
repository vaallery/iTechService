class PaymentPolicy < BasePolicy
  def create?
    any_manager?(:software)
  end
end
