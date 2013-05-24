class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  before_filter :authenticate_user!, :set_current_user
  before_filter :store_location, except: [:create, :update, :destroy]
  before_filter :check_birthdays, if: :user_signed_in?
  before_filter :load_important_info, if: :user_signed_in?
  before_filter :load_personal_infos, if: :user_signed_in?
  layout 'staff'

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    flash[:error] = exception.message
    redirect_back_or root_url, alert: exception.message
  end

  private

  def set_current_user
    User.current = current_user
  end

  def check_birthdays
    if current_user.admin?
      User.find_each do |user|
        user.birthday_announcement.update_attributes active: user.upcoming_birthday?
      end
    end
  end

  def load_important_info
    @important_info = Info.unarchived.important.first
  end

  def load_personal_infos
    @personal_infos = Info.unarchived.addressed_to current_user
  end

end
