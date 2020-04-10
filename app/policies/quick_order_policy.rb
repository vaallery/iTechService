class QuickOrderPolicy < BasePolicy
  def create?
    any_manager?(:software, :media)
  end

  def update?
    any_manager?(:media) || (has_role?(:software) && record.user_id == user.id)
  end

  def set_done?
    any_manager?(:software, :media)
  end
end
