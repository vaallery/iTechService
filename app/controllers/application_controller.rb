class ApplicationController < ActionController::Base
  include Trailblazer::Operation::Controller
  include ApplicationHelper
  protect_from_forgery
  # before_action :auto_sign_in
  before_filter :authenticate_user!
  before_filter :set_current_user
  before_filter :store_location, except: [:create, :update, :destroy]
  # layout 'staff'
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from CanCan::AccessDenied, with: :not_authorized

  private

  def auto_sign_in
    if Rails.env.development?
      user = User.find_by(username: 'vova')
      sign_in user if user.present?
    end
  end

  def set_current_user
    User.current = current_user
  end

  def params!(params)
    params.merge current_user: current_user
  end

  def not_authorized(exception)
    Rails.logger.debug "Access denied on #{exception.try(:action)} #{exception.try(:subject).try(:inspect)}"
    message = exception.try :message
    flash[:error] = message
    redirect_to request.referrer || root_url, alert: message
  end

  def setup_operation_instance_variables!(operation, options)
    @operation = operation
    instance_variable_set "@#{operation.model_name}", operation.model
    @form = operation.contract unless options[:skip_form]
  end
end
