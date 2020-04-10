class GiftCertificatePolicy < BasePolicy
  def issue?
    same_department? && has_role?(*MANAGER_ROLES, :software)
  end

  def activate?
    same_department? && has_role?(*MANAGER_ROLES, :software)
  end

  def scan?
    same_department? && has_role?(*MANAGER_ROLES, :software)
  end

  def find?
    same_department? && has_role?(*MANAGER_ROLES, :software)
  end
end
