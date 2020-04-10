class FaultKindPolicy < CommonPolicy
  def manage?; any_admin?; end
end
