class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :set_current_user
  before_filter :store_location, except: [:create, :update, :destroy]
  before_filter :load_important_info, if: :user_signed_in?
  before_filter :load_personal_infos, if: :user_signed_in?
  before_filter :load_announcements, if: :user_signed_in?
  layout 'staff'

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    flash[:error] = exception.message
    redirect_to root_url, alert: exception.message
  end

  private

  def set_current_user
    User.current = current_user
  end

  def load_important_info
    @important_info = Info.unarchived.important.first
  end

  def load_personal_infos
    @personal_infos = Info.unarchived.addressed_to current_user
  end

  def load_announcements
    @announcements = Announcement.active.keep_if do |announcement|
      announcement.visible_for? current_user
    end
  end

end
