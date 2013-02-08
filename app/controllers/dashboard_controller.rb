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

  def reports
    render nothing: true unless current_user.admin?
    @start_date = params[:start_date] || DateTime.current.yesterday
    @end_date = params[:end_date] || DateTime.current.yesterday
    period = [@start_date.beginning_of_day..@end_date.end_of_day]
    @received_devices = Device.where(created_at: period)
    @report = {}
    @report[:devices_received_count] = @received_devices.count
    @report[:devices_received_done_count] = @received_devices.at_done.count
    @report[:devices_received_archived_count] = @received_devices.at_archive.count
    @report[:device_types] = []
    @received_devices.group('device_type_id').count('id').each_pair do |key, val|
      if key.present? and (device_type = DeviceType.find key).present?
        @report[:device_types] << [device_type.full_name, val, device_type.devices.at_done.count, device_type.devices.at_archive.count]
      end
    end
    @report[:users] = []
    @received_devices.group('user_id').count('id').each_pair do |key, val|
      if key.present? and (user = User.find key).present?
        @report[:users] << [user.short_name, val, user.devices.at_done.count, user.devices.at_archive.count]
      end
    end

    @report[:tasks] = []
    DeviceTask.where(device_id: @received_devices.map{|d|d.id}).done.group(:task_id).sum(:cost).each_pair do |key, val|
      if key.present? and (task = Task.find key).present?
        @report[:tasks] << [task.name, val]
      end
    end
    @report[:tasks_sum] = DeviceTask.where(device_id: @received_devices.map{|d|d.id}).done.sum(:cost)
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
