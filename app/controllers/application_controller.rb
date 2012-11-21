class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  before_filter :authenticate_user!
  
  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
  flash[:error] = exception.message
    redirect_to root_url, alert: exception.message
  end
end
