class SalesImportPolicy < ApplicationPolicy
  def manage?
    any_manager?(:marketing)
  end
end
