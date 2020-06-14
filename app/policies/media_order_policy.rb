class MediaOrderPolicy < BasePolicy
  def create?
    any_manager?(:media, :universal)
  end

  def update?
    same_department? && any_manager?(:media, :universal)
  end
end
