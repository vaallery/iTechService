class DashboardController < ApplicationController

  skip_before_filter :authenticate_user!, :set_current_user, only: :sign_in_by_card

  def index
    if current_user.marketing?
      load_actual_orders
      @table_name = 'orders_table'
    else
      load_actual_devices
      @table_name = 'tasks_table'
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def actual_orders
    load_actual_orders
    respond_to do |format|
      format.js
    end
  end

  def actual_tasks
    load_actual_devices
    respond_to do |format|
      format.js
    end
  end

  def ready_devices
    @devices = Device.at_done.search(params).page params[:page]
    respond_to do |format|
      format.js
    end
  end

  def goods_for_sale
    @device_types = DeviceType.for_sale
    respond_to do |format|
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
      sign_in :user, User.find(params[:id])
    end
    redirect_to root_url
  end

  private

  def load_actual_devices
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
  end

  def load_actual_orders
    @orders = Order.actual_orders.search(params).page params[:page]
  end

end
