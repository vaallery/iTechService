class SupplyReportPolicy < BasePolicy
  def manage?; any_admin?; end

  def read?
    any_admin?(:driver)
  end

  def create?
    any_admin?(:driver)
  end
end
