class GiftCertificatePolicy < BasePolicy
  def issue?
    same_department? && any_manager?(:software, :universal)
  end

  def activate?
    same_department? && any_manager?(:software, :universal)
  end

  def scan?
    same_department? && any_admin?(:software, :universal)
  end

  def find?
    same_department? && any_manager?(:software, :universal)
  end
end
