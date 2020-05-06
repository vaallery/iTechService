class StorePolicy < BasePolicy
  def modify?
    superadmin? || same_department? && any_manager?
  end

  def show?
    superadmin? || able_to?(:manage_stocks) || same_department? && any_manager?
  end

  def destroy?; false; end

  def product_details?; show?; end

  class Scope < Scope
    def resolve
      if user.superadmin? || user.able_to?(:manage_stocks)
        scope.all
      else
        super
      end
    end
  end
end
