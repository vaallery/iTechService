class ApplicationController < ActionController::Base
  include Trailblazer::Operation::Controller
  include ApplicationHelper
  protect_from_forgery with: :exception
  # before_action :auto_sign_in
  before_filter :authenticate_user!
  before_filter :set_current_user
  before_filter :store_location, except: [:create, :update, :destroy]
  # layout 'staff'

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    flash[:error] = exception.message
    redirect_to root_url, alert: exception.message
  end

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

end
