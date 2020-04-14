class BasePolicy < ApplicationPolicy
  def manage?; any_manager?; end

  def read?; true; end

  def index?; read?; end

  def create?; manage?; end

  def show?
    same_department? && read?
  end

  def update?
    same_department? && manage?
  end

  def destroy?
    same_department? && manage?
  end

  class Scope < Scope
    def resolve
      return super if user.superadmin?

      if scope.column_names.include?('department_id')
        scope.where(department_id: user.department_id)
      else
        scope.in_department(user.department_id)
      end
    end
  end
end
