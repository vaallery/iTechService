class MovementActPolicy < DocumentPolicy
  def create?
    any_manager? ||
      (has_role?(:technician) && record.is_new? && record.is_spare_parts_to_defect?)
  end

  def make_defect_sp?
    has_role?(*MANAGER_ROLES, :technician)
  end
end
