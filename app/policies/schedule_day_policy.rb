class ScheduleDayPolicy < BasePolicy
  def manage?
    any_admin? || able_to?(:manage_schedule)
  end
end
