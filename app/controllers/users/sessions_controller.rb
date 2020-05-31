class Users::SessionsController < Devise::SessionsController
  layout 'auth'
  respond_to :html, :json
  skip_after_action :verify_authorized
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super do |user|
      if user.department_autochangeable?
        unless autochange_department(user)
          return redirect_to edit_user_department_path
        end
      end
    end
  end

  def sign_in_by_card
    respond_to do |format|
      if (user = User.find_by_card_number(params[:card_number])).present?
        if params[:current_user].to_i == user.id
          sign_in :user, user, bypass: true
        else
          sign_in :user, user
        end

        location = after_sign_in_path_for(user)
        if user.department_autochangeable?
          unless autochange_department(user)
            location = edit_user_department_path
          end
        end

        format.json { respond_with user, location: location }
      else
        format.json { respond_with({error: 'user_not_found'}, location: new_user_session_url) }
      end
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

  def autochange_department(user)
    return true if Department.count < 2

    return true if user.department.ip_network.blank? || user.department.ip_network == user.current_sign_in_ip

    new_department = Department.find_by(ip_network: user.current_sign_in_ip)
    return false if new_department.nil?

    change_user_department user, new_department
  end
end
