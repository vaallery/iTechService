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
      render json: user
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
    @start_date = (params[:start_date] || 1.day.ago).to_datetime
    @end_date = (params[:end_date] || 1.day.ago).to_datetime
    @period = [@start_date.beginning_of_day..@end_date.end_of_day]
    @received_devices = Device.where(created_at: @period)
    @report = {}
    @report[:devices_received_count] = @received_devices.count
    @report[:devices_received_done_count] = @received_devices.at_done.count
    @report[:devices_received_archived_count] = @received_devices.at_archive.count

    make_report_by_device_types
    make_report_by_users
    make_report_by_tasks
    make_report_by_clients
    make_report_by_tasks_durations
  end

  def check_session_status
    render json: {timeout: !user_signed_in?}
  end

  private

  def load_actual_devices
    if current_user.admin?
      if params[:location].present?
        location = Location.find params[:location]
        @devices = Device.located_at(location)
        @location_name = location.full_name
      else
        @devices = Device.pending
      end
    else
      @devices = Device.located_at(current_user.location)
    end
    @devices = @devices.search(params).oldest.page params[:page]
  end

  def load_actual_orders
    @orders = Order.actual_orders.search(params).oldest.page params[:page]
  end

  def make_report_by_device_types
    @report[:device_types] = []
    if @received_devices.any?
      @received_devices.group('device_type_id').count('id').each_pair do |key, val|
        if key.present? and (device_type = DeviceType.find key).present?
          devices = @received_devices.where(device_type_id: key)
          @report[:device_types] << {name: device_type.full_name, qty: val, qty_done: devices.at_done.count, qty_archived: devices.at_archive.count}
        end
      end
    end
  end

  def make_report_by_users
    @report[:users] = []
    if @received_devices.any?
      @received_devices.group('user_id').count('id').each_pair do |key, val|
        if key.present? and (user = User.find key).present?
          devices = @received_devices.where(user_id: key)
          @report[:users] << {name: user.short_name, qty: val, qty_done: devices.at_done.count, qty_archived: devices.at_archive.count}
        end
      end
    end
  end

  def make_report_by_tasks
    archived_devices_ids = HistoryRecord.devices.movements_to_archive.in_period(@period).collect{|hr|hr.object_id}.uniq
    @report[:tasks] = []
    @report[:tasks_sum] = 0
    @report[:tasks_qty] = 0
    @report[:tasks_qty_free] = 0
    if archived_devices_ids.any?
      tasks = DeviceTask.where device_id: archived_devices_ids
      tasks.collect{|t|t.task_id}.uniq.each do |task_id|
        task = Task.find task_id
        task_name = task.name
        same_tasks = tasks.where(task_id: task_id)
        task_sum = same_tasks.sum(:cost)
        task_count = same_tasks.count
        task_paid_count = same_tasks.where('cost > 0').count
        task_free_count = same_tasks.where(cost: [0,nil]).count
        devices = same_tasks.collect do |same_task|
          {id: same_task.device_id, name: same_task.device.type_name, cost: same_task.cost}
        end
        @report[:tasks] << {name: task_name, sum: task_sum, qty: task_count, qty_paid: task_paid_count,
                            qty_free: task_free_count, devices: devices}
      end

      @report[:tasks_sum] = tasks.sum(:cost)
      @report[:tasks_qty] = tasks.count
      @report[:tasks_qty_paid] = tasks.where('cost > 0').count
      @report[:tasks_qty_free] = tasks.where(cost: [0,nil]).count
    end
  end

  def make_report_by_clients
    @report[:clients_count] = Client.count
    @report[:new_clients_count] = Client.where(created_at: @period).count
  end

  def make_report_by_tasks_durations
    #было бы не плохо посмотреть из чего эти задачи состоят или минуты.
    # То есть нажимаешь на цифру и видишь какие устройства где лежат.
    @report[:tasks_durations] = []
    Task.find_each do |task|
      task_durations = []
      device_tasks = []
      HistoryRecord.devices.movements_to(task.location_id).in_period(@period).each do |hr|
        moved_at = hr.created_at
        durations = []
        hr.object.device_tasks.done.where(task_id: task.id).each do |dt|
          done_at = dt.done_at
          dt_duration = ((done_at - moved_at).to_i/60).round
          durations << dt_duration
          device_tasks << {device: dt.device_presentation, device_id: dt.device_id, moved_at: moved_at,
                           done_at: done_at, duration: dt_duration, moved_by: hr.user_name, done_by: dt.performer_name,
                           device_location: dt.device.location_name}
        end
        unless durations.empty?
          task_durations << (durations.sum/durations.size).round
        end
      end
      average_duration = task_durations.present? ? (task_durations.sum/task_durations.size).round : 0
      @report[:tasks_durations] << {task_name: task.name, average_duration: average_duration, device_tasks: device_tasks}
    end
  end

end
