class DeviceTaskPolicy < BasePolicy
  def update?
    same_department? &&
      (any_admin? || record.is_actual_for?(user))
  end
end
