class ReportPolicy < ApplicationPolicy
  def manage?
    superadmin? || able_to?(:view_reports)
  end
end
