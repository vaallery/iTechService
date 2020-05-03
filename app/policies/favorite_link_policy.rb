class FavoriteLinkPolicy < ApplicationPolicy
  def manage?
    record.owner_id == user.id
  end

  def create?; true end
end
