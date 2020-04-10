class PaymentPolicy < BasePolicy
  def create?
    has_role?(*MANAGER_ROLES, :software)
  end
end
