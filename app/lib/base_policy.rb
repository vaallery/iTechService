class BasePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    any_admin?
  end

  def show?
    any_admin?
  end

  def create?
    any_admin?
  end

  def new?
    create?
  end

  def update?
    any_admin?
  end

  def edit?
    update?
  end

  def destroy?
    any_admin?
  end

  def manage?
    any_admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  private

  def any_admin?
    user.any_admin?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end