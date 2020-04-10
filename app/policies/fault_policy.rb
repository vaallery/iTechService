class FaultPolicy < ApplicationPolicy
  def read?
    same_department? && (manage? || (record.causer_id == user.id))
  end

  def manage?
    any_admin?
  end

  def create?
    manage?
  end

  def update?
    same_department? && manage?
  end

  def destroy?
    same_department? && superadmin?
  end
end
