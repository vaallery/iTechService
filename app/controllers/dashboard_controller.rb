class DashboardController < ApplicationController

  skip_before_filter :authenticate_user!, :set_current_user, only: [:sign_in_by_card, :check_session_status]

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

  def actual_supply_requests
    @supply_requests = SupplyRequest.actual.page params[:page]
    @table_name = 'requests_table'
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
    respond_to do |format|
      if (user = User.find_by_card_number params[:card_number]).present?
        if params[:current_user].to_i == user.id
          sign_in :user, user, bypass: true
        else
          sign_in :user, user
        end
        format.json { render json: user }
      else
        format.json { redirect_to new_user_session_url }
      end
    end
  end

  def become
    if Rails.env.development?
      sign_in :user, User.find(params[:id])
    end
    redirect_to root_url
  end

  def check_session_status
    render json: {timeout: !user_signed_in?}
  end

  private

  def load_actual_devices
    if current_user.any_admin?
      if params[:location].present?
        location = Location.find params[:location]
        @devices = Device.located_at(location)
        @location_name = location.name
      else
        @devices = Device.pending
      end
    elsif current_user.location.present?
      @devices = Device.located_at(current_user.location)
    else
      @devices = Device.where location_id: nil
    end
    if current_user.able_to? :print_receipt
      @devices = @devices.search(params).newest.page params[:page]
    else
      @devices = @devices.search(params).oldest.page params[:page]
    end
  end

  def load_actual_orders
    if current_user.technician?
      @orders = Order.actual_orders.technician_orders.search(params).oldest.page params[:page]
    else
      @orders = Order.actual_orders.marketing_orders.search(params).oldest.page params[:page]
    end
  end

end
