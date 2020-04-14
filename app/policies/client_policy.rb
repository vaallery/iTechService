class ClientPolicy < BasePolicy
  def create?
    any_manager?(:software, :media)
  end

  def update?
    same_department? && (any_manager?(:marketing) || able_to?(:edit_clients))
  end

  def destroy?
    same_department? && any_admin?
  end

  def select?; read?; end

  def find?; read?; end

  def export?
    superadmin?
  end

  def change_category?
    superadmin? || (same_department? && admin?)
  end
end
