class MediaOrderPolicy < BasePolicy
  def create?
    has_role?(*MANAGER_ROLES, :media)
  end

  def update?
    same_department? && has_role?(*MANAGER_ROLES, :media)
  end
end
