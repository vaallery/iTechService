class CommentPolicy < BasePolicy
  def create?; true; end

  def update?
    super || (record.user_id == user.id)
  end
end
