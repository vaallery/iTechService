class CommonPolicy < ApplicationPolicy
  def read?
    true
  end

  def manage?
    any_manager?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
