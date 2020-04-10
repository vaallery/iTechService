module Service
  class RepairReturnPolicy < BasePolicy
    def create?
      has_role?(*MANAGER_ROLES, :technician)
    end
  end
end
