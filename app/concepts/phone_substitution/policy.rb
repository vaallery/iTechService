class PhoneSubstitution::Policy < BasePolicy
  delegate :pending?, to: :record

  def create?
    user.present? && !pending?
  end

  def update?
    user.present? && pending?
  end
end
