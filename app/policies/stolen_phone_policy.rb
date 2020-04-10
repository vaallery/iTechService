class StolenPhonePolicy < ApplicationPolicy
  def read?; true; end

  def manage?
    any_admin?
  end
end