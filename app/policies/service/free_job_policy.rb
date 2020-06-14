module Service
  class FreeJobPolicy < BasePolicy
    def show?
      view_everywhere? ||
        (same_department? && any_admin?) ||
        (record.receiver == user)
    end

    def create?
      any_manager?(:software, :universal)
    end

    def view_everywhere?
      superadmin? || able_to?(:view_quick_orders_and_free_jobs_everywhere)
    end

    class Scope < Scope
      def resolve
        if user.superadmin? || user.able_to?(:view_quick_orders_and_free_jobs_everywhere)
          scope.all
        else
          scope.in_department(user.department)
        end
      end
    end
  end
end
