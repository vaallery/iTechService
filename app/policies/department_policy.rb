class DepartmentPolicy < CommonPolicy
  def destroy?; any_admin?; end
end
