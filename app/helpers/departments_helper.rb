module DepartmentsHelper

  def department_roles_for_select
    Department::ROLES.to_a.map {|r| [t("departments.roles.#{r[1]}"), r[0]]}
  end

  def human_department_role(department)
    t "departments.roles.#{department.role_s}"
  end

end
