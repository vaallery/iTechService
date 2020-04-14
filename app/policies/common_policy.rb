class CommonPolicy < ApplicationPolicy
  def read?
    true
  end

  def manage?
    any_manager?
  end
end
