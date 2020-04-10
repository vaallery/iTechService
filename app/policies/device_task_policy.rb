class DeviceTaskPolicy < BasePolicy
  def update?
    same_department? &&
      (any_admin? || (record.role == user.role))
  end
end
