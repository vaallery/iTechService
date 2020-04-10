class ServiceJobViewingPolicy < ApplicationPolicy
  def read?
    superadmin?
  end
end
