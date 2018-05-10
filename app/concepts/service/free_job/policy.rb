module Service
  class FreeJob::Policy < BasePolicy
    def show?
      any_admin? || record.performer == user
    end

    def create?
      user.present?
    end
  end
end
