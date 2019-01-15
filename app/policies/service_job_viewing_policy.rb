class ServiceJobViewingPolicy < BasePolicy
  def index?
    superadmin?
  end
end
