class OrderPolicy < BasePolicy
  def create?; true; end

  def update?
    same_department? && has_role?(:superadmin, :admin, :manager, :media, :marketing, :technician)
  end

  def destroy?
    (same_department? && manage?) || (record.user_id == user.id)
  end
end
