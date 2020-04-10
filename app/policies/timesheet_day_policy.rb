class TimesheetDayPolicy < BasePolicy
  def manage?
    any_admin? || able_to?(:manage_timesheet)
  end
end
