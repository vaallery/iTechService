class PhoneSubstitutionPolicy < BasePolicy
  def create?
    !record.pending?
  end

  def update?
    same_department? && record.pending?
  end
end
