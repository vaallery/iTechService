class FaultKind < ApplicationRecord
  class Policy < ItechService::Policy

    def index?
      user.any_admin?
    end

    def create?
      user.any_admin?
    end

    def update?
      user.any_admin?
    end

    def destroy?
      user.any_admin?
    end
  end
end