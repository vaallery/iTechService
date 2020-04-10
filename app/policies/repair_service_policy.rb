class RepairServicePolicy < CommonPolicy
  def choose?
    any_manager?(:technician)
  end

  def select?; choose?; end

  def mass_update?; update?; end
end
