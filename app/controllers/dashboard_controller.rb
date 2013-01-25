class DashboardController < ApplicationController

  skip_before_filter :authenticate_user!, :set_current_user, only: :sign_in_by_card

  def index
    case params[:tab]
      when 'actual_tasks'
        @devices = (current_user.admin? ? Device.pending : Device.located_at(current_user.location)).page params[:page]
        @table_name = 'tasks_table'
      when 'made_devices'
        @devices = Device.done.page params[:page]
        @table_name = 'made_devices'
      when 'goods_for_sale'
        @device_types = DeviceType.for_sale
        @table_name = 'goods_for_sale'
      else
        @devices = (current_user.admin? ? Device.pending : Device.located_at(current_user.location)).page params[:page]
        @table_name ||= 'tasks_table'
    end
    respond_to do |format|
      format.html { render 'index' }
      format.js
    end
  end

  def sign_in_by_card
    if (user = User.find_by_card_number params[:card_number]).present?
      sign_in :user, user
      redirect_to root_url
    else
      redirect_to new_user_session_url
    end
  end

  def become
    if Rails.env.development?
      sign_in :user, User.find(params[:id]), bypass: true
    end
    redirect_to root_url
  end

end
