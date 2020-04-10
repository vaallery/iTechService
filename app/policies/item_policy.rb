class ItemPolicy < CommonPolicy
  def autocomplete?; read?; end

  def manage?; any_manager?; end

  def modify?
    has_role?(*MANAGER_ROLES, :software)
  end

  def remains_in_store?
    has_role?(*MANAGER_ROLES, :software)
  end
end
