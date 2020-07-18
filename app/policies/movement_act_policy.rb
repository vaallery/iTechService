class MovementActPolicy < DocumentPolicy
  def index?
    manage?
  end

  def manage?
    superadmin? || able_to?(:manage_stocks)
  end

  def create?
    manage? ||
      (has_role?(:admin, :technician) && record.is_new? && record.is_spare_parts_to_defect?)
  end

  def modify?
    manage? ||
      (has_role?(:admin, :technician) && record.is_spare_parts_to_defect?)
  end

  def make_defect_sp?
    manage? || has_role?(:admin, :technician)
  end
end
