class MediaOrderPolicy < CommonPolicy
  def create?
    any_manager?(:media, :universal)
  end

  def update?
    any_manager?(:media, :universal)
  end
end
