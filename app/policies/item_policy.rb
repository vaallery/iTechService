class ItemPolicy < CommonPolicy
  def autocomplete?; read?; end

  def select?; read?; end

  def check_status?; read?; end

  def manage?; any_manager?; end

  def modify?
    any_manager?(:software)
  end

  def remains_in_store?
    any_manager?(:software)
  end
end
