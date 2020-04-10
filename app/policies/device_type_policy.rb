class DeviceTypePolicy < CommonPolicy
  def manage?
    has_role?(*MANAGER_ROLES, :marketing)
  end
end
