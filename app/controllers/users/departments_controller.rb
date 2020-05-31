class Users::DepartmentsController < ApplicationController
  skip_after_action :verify_authorized

  def edit
    @departments = current_user.superadmin? ? Department.all : Department.in_city(current_user.city)
  end

  def update
    department = Department.find(params[:user][:department_id])
    change_user_department current_user, department
    redirect_to root_path
  end
end
