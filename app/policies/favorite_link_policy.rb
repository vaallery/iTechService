class FavoriteLinkPolicy < ApplicationPolicy
  def manage?
    record.owner_id == user.id
  end
end
