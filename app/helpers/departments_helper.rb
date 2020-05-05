module DepartmentsHelper
  def current_department
    Department.current
  end

  def department_roles_for_select
    Department::ROLES.to_a.map { |r| [t("departments.roles.#{r[1]}"), r[0]] }
  end

  def human_department_role(department)
    t "departments.roles.#{department.role_s}"
  end

  def local_departments_collection
    Department.selectable.in_city(current_user.city)
  end

  def department_tag(department)
    content_tag :span, department.name, class: 'department_name',
                style: "background-color: #{department.color}"
  end
end
