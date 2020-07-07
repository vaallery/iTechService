class AppLogoPolicy < ApplicationPolicy
  def manage?
    superadmin?
  end
end
