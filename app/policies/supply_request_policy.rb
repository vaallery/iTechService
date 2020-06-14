class SupplyRequestPolicy < BasePolicy
  def manage?
    any_manager? || has_role?(:technician, :universal, :media) && record.user_id == user.id && record.is_new?
  end

  def read?
    any_manager?(:driver, :technician, :universal, :media)
  end

  def create?
    any_manager?(:technician, :universal, :media)
  end

  def make_done?
    manage? || (same_department? && has_role?(:driver) && record.is_new?)
  end

  def make_new?
    manage? || (same_department? && has_role?(:driver) && record.is_done?)
  end
end
