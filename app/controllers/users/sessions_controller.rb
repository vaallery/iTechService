class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super do |user|
      change_department(user) if user.department_autochangeable?
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def change_department(user)
    return if Department.count < 2
    user_network = user.current_sign_in_ip.gsub(/\d+$/, '')
    return if user.department.ip_network.include?(user_network)
    new_department = Department.find_by_network(user_network)
    return if new_department.nil?
    user.department = new_department
    if user.location.present?
      new_location = Location.find_by(department: new_department, code: user.location.code)
      user.location = new_location if new_location.present?
    end
    user.save
  end
end
