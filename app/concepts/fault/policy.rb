class Fault < ApplicationRecord
  class Policy < BasePolicy

    def index?
      user.any_admin?
    end

    def create?
      user.any_admin? || (record.causer_id == user.id)
    end

    def update?
      user.any_admin?
    end

    def destroy?
      user.superadmin?
    end
  end
end