class MediaOrderPolicy < BasePolicy
  def create?
    any_manager?(:media)
  end

  def update?
    same_department? && any_manager?(:media)
  end
end
