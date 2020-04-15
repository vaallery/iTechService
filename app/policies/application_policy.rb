class ApplicationPolicy
  ADMIN_ROLES = %i[superadmin admin]
  MANAGER_ROLES = %i[superadmin admin manager]

  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "Must be signed in." unless user

    @user = user
    @record = record
  end

  def manage?
    superadmin?
  end

  def modify?
    manage?
  end

  def read?
    modify?
  end

  def index?
    read?
  end

  def show?
    read?
  end

  def create?
    manage? || modify?
  end

  def new?
    create?
  end

  def update?
    manage? || modify?
  end

  def edit?
    update?
  end

  def destroy?
    manage?
  end

  private

  def same_department?
    superadmin? ||
      user.department_id == record.department_id ||
      record.new_record?
  end

  def any_manager?(*additional_roles)
    has_role? *MANAGER_ROLES, *additional_roles
  end

  def any_admin?(*additional_roles)
    has_role? *ADMIN_ROLES, *additional_roles
  end

  def superadmin?
    user.superadmin?
  end

  def admin?
    user.admin?
  end

  def has_role?(*roles)
    roles.any? { |role| user.role == role.to_s }
  end

  def able_to?(ability)
    user.abilities.include?(ability.to_s)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
