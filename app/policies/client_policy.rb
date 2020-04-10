class ClientPolicy < BasePolicy
  def create?
    has_role?(:superadmin, :admin, :manager, :software, :media)
  end

  def update?
    same_department? && (has_role?(*MANAGER_ROLES, :marketing) || able_to?(:edit_clients))
  end

  def destroy?
    same_department? && any_admin?
  end
end
