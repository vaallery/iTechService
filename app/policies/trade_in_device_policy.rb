class TradeInDevicePolicy < BasePolicy
  def manage?
    superadmin? || able_to?(:manage_trade_in)
  end

  def create?; true; end

  def index?; true; end

  def show?; true; end

  def print?; true; end

  def index_unconfirmed?
    manage?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.superadmin? || user.able_to?(:manage_trade_in)

      if scope.column_names.include?('department_id')
        scope.where(department_id: user.department_id)
      else
        scope.in_department(user.department_id)
      end
    end
  end
end
