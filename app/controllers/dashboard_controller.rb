class DashboardController < ApplicationController

  skip_before_filter :authenticate_user!, :set_current_user, only: :sign_in_by_card

  def index
    params[:tab] ||= 'actual_orders' if current_user.marketing?
    case params[:tab]
      when 'actual_tasks'
        if current_user.admin?
          if params[:location].present?
            location = Location.find params[:location]
            @devices = Device.pending.located_at(location)
            @location_name = location.full_name
          else
            @devices = Device.pending
          end
        else
          @devices = Device.pending.located_at(current_user.location)
        end
        @devices = @devices.search(params).page params[:page]
        @table_name = 'tasks_table'
      when 'made_devices'
        @devices = Device.at_done.search(params).page params[:page]
        @table_name = 'made_devices'
      when 'goods_for_sale'
        @device_types = DeviceType.for_sale
        @table_name = 'goods_for_sale'
      when 'actual_orders'
        @orders = Order.ordered.actual_orders.page params[:page]
        @table_name = 'orders_table'
      else
        @devices = (current_user.admin? ? Device.pending : Device.located_at(current_user.location)).page params[:page]
        @table_name ||= 'tasks_table'
    end
    respond_to do |format|
      format.html { render 'index' }
      format.js
    end
  end

  def actual_orders
    respond_to do |format|
      format.html
      format.js
    end
  end

  def actual_tasks
    respond_to do |format|
      format.html
      format.js
    end
  end

  def ready_devices
    respond_to do |format|
      format.html
      format.js
    end
  end

  def goods_for_sale
    respond_to do |format|
      format.html
      format.js
    end
  end

  def sign_in_by_card
    if (user = User.find_by_card_number params[:card_number]).present?
      sign_in :user, user
      #render root_url
      redirect_to root_url
      #redirect_back_or root_url
    else
      redirect_to new_user_session_url
    end
  end

  def become
    if Rails.env.development?
      sign_in :user, User.find(params[:id])#, bypass: true
    end
    redirect_to root_url
  end

end
