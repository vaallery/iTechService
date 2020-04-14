class GiftCertificatePolicy < BasePolicy
  def issue?
    same_department? && any_manager?(:software)
  end

  def activate?
    same_department? && any_manager?(:software)
  end

  def scan?
    same_department? && any_admin?(:software)
  end

  def find?
    same_department? && any_manager?(:software)
  end
end
