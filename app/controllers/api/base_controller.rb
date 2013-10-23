module Api

  class BaseController < ActionController::Base
    protect_from_forgery
    before_filter :authenticate_user!
    before_filter :set_current_user
    respond_to :json

    rescue_from CanCan::AccessDenied do |exception|
      Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
      flash[:error] = exception.message
      redirect_back_or root_url, alert: exception.message
    end

    private

    def set_current_user
      User.current = current_user
    end

  end

end