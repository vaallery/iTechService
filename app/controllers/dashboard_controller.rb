class DashboardController < ApplicationController

  skip_before_filter :authenticate_user!, :set_current_user, only: :sign_in_by_card

  def index
    #@device_tasks = DeviceTask.pending
    #@device_tasks = @device_tasks.tasks_for current_user unless current_user.admin?
    #@device_tasks = @device_tasks.page params[:page]
    @devices = Device.pending.page params[:page]
    respond_to do |format|
      format.html { render 'index' }
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

  def goods_for_sale
    @device_types = DeviceType.for_sale
  end

end
