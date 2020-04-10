module Service
  class FreeJobPolicy < BasePolicy
    def show?
      (same_department? && any_admin?) ||
        (record.receiver == user)
    end

    def create?
      has_role?(*MANAGER_ROLES, :software)
    end
  end
end
