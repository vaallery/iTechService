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

  def reports
    render nothing: true unless current_user.can_view_reports?
    @start_date = (params[:start_date] || 1.day.ago).to_datetime
    @end_date = (params[:end_date] || 1.day.ago).to_datetime
    @period = [@start_date.beginning_of_day..@end_date.end_of_day]
    @received_devices = Device.where(created_at: @period)
    @report = {}
    @report[:devices_received_count] = @received_devices.count
    @report[:devices_received_done_count] = @received_devices.at_done.count
    @report[:devices_received_archived_count] = @received_devices.at_archive.count

    case params[:report]
      when 'device_types_report' then make_device_types_report params[:device_type]
      when 'users_report' then make_users_report
      when 'tasks_report' then make_done_tasks_report
      when 'clients_report' then make_clients_report
      when 'tasks_durations_report' then make_tasks_duration_report
      when 'done_orders_report' then make_done_orders_report
      when 'devices_movements_report' then make_devices_movements_report
      when 'sales_report' then make_sales_report
      when 'salaries_report' then can?(:manage, Salary) ? make_salaries_report : render(nothing: true)
    end
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
        @location_name = location.full_name
      else
        @devices = Device.pending
      end
    elsif current_user.location.present?
      @devices = Device.located_at(current_user.location)
    else
      @devices = Device.where location_id: nil
    end
    @devices = @devices.search(params).oldest.page params[:page]
  end

  def load_actual_orders
    if current_user.technician?
      @orders = Order.actual_orders.technician_orders.search(params).oldest.page params[:page]
    else
      @orders = Order.actual_orders.marketing_orders.search(params).oldest.page params[:page]
    end
  end

  def make_device_types_report(device_type_id)
    @report[:device_types] = []
    @current_device_type = DeviceType.find(device_type_id) if device_type_id.present?
    device_types = device_type_id.present? ? @current_device_type.children : DeviceType.roots
    device_types.each do |device_type|
      device_ids = []
      device_type.descendants.each do |sub_device_type|
        if sub_device_type.is_childless?
          device_ids << sub_device_type.devices.where(created_at: @period).map { |d| d.id }
        end
      end
      received_devices = Device.where id: device_ids
      qty_received = received_devices.count
      qty_done = received_devices.at_done.count
      qty_archived = received_devices.at_archive.count
      @report[:device_types] << {device_type: device_type, qty: qty_received,
                                 qty_done: qty_done, qty_archived: qty_archived}
      @report[:devices_received_count] += qty_received
      @report[:devices_received_done_count] += qty_done
      @report[:devices_received_archived_count] += qty_archived
    end
  end

  def make_users_report
    @report[:users] = []
    if @received_devices.any?
      @received_devices.group('user_id').count('id').each_pair do |key, val|
        if key.present? and (user = User.find key).present?
          devices = @received_devices.where(user_id: key)
          #user_devices = devices.map{|d|{id: d.id, presentation: d.presentation}}
          @report[:users] << {name: user.short_name, qty: val, qty_done: devices.at_done.count,
                              qty_archived: devices.at_archive.count, devices: devices}
        end
      end
    end
  end

  def make_done_tasks_report
    archived_devices_ids = HistoryRecord.devices.movements_to_archive.in_period(@period).collect { |hr| hr.object_id }.uniq
    @report[:tasks] = []
    @report[:tasks_sum] = 0
    @report[:tasks_qty] = 0
    @report[:tasks_qty_free] = 0
    if archived_devices_ids.any?
      tasks = DeviceTask.where device_id: archived_devices_ids
      tasks.collect { |t| t.task_id }.uniq.each do |task_id|
        task = Task.find task_id
        task_name = task.name
        same_tasks = tasks.where(task_id: task_id)
        task_sum = same_tasks.sum(:cost)
        task_count = same_tasks.count
        task_paid_count = same_tasks.where('cost > 0').count
        task_free_count = same_tasks.where(cost: [0, nil]).count
        devices = same_tasks.collect do |same_task|
          {id: same_task.device_id, name: same_task.device.type_name, cost: same_task.cost}
        end
        @report[:tasks] << {name: task_name, sum: task_sum, qty: task_count, qty_paid: task_paid_count,
                            qty_free: task_free_count, devices: devices}
      end

      @report[:tasks_sum] = tasks.sum(:cost)
      @report[:tasks_qty] = tasks.count
      @report[:tasks_qty_paid] = tasks.where('cost > 0').count
      @report[:tasks_qty_free] = tasks.where(cost: [0, nil]).count
    end
  end

  def make_clients_report
    @report[:clients_count] = Client.count
    @report[:new_clients_count] = Client.where(created_at: @period).count
    @report[:new_clients] = Client.where(created_at: @period)
  end

  def make_tasks_duration_report
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

  def make_done_orders_report
    @report[:orders] = []
    done_orders = Order.done_at @period
    done_orders.find_each do |order|
      @report[:orders] << {order: order, done_at: order.done_at}
    end
    @report[:done_orders_count] = done_orders.count
  end

  def make_devices_movements_report
    @report[:users_mv] = []
    movements = HistoryRecord.in_period(@period)
    movements = movements.movements_from(Location.bar_id)
    movements = movements.movements_to([Location.content_id, Location.repair_id])
    if movements.any?
      movements.group('user_id').count('id').each_pair do |key, val|
        if key.present? and (user = User.find key).present?
          user_movements = movements.by_user(user)
          devices = []
          user_durations = []
          user_movements.each do |movement|
            if (device = Device.find(movement.object_id)).present?
              old_location = Location.find movement.old_value.to_i
              new_location = Location.find movement.new_value.to_i
              duration = ((movement.created_at - device.created_at).to_i/60).round
              user_durations << duration
              devices << {moved_at: movement.created_at, created_at: device.created_at,
                          old_location: old_location.name, new_location: new_location.name,
                          device_id: device.id, device_presentation: device.presentation,
                          client_id: device.client_id, client_presentation: device.client_presentation,
                          duration: duration}
            end
          end
          avarage_duration = (user_durations.sum / user_durations.size).round
          @report[:users_mv] << {user: user.short_name, avarage_duration: avarage_duration, qty: val, devices: devices}
        end
      end
    end
  end

  def make_salaries_report
    @report[:salaries] = []
    salaries = Salary.issued_at @period
    salaries.find_each do |salary|
      @report[:salaries] << { issued_at: salary.issued_at, user: salary.user.short_name, amount: salary.amount }
    end
    @report[:salaries_sum] = salaries.sum :amount
  end

  def make_sales_report
    @report[:sales] = []
    sales_sum = 0
    sales_count = 0
    sales = Sale.sold_at(@period)
    users_sales = sales.where('sales.user_id IS NOT NULL').group('sales.user_id').sum('sales.value')
    users_sales.each_pair do |user_id, sum|
      if (user = User.find user_id).present?
        user_sales = sales.where user_id: user_id
        user_sales_hash = []
        user_sales.each do |sale|
          client_hash = sale.client.present? ? { id: sale.client_id, name: sale.client_presentation } : {}
          user_sales_hash << { sold_at: sale.sold_at, device_type: sale.device_type_name, serial_number: sale.serial_number, imei: sale.imei, value: sale.value, id: sale.id, client: client_hash }
          sales_sum = sales_sum + sale.value
          sales_count = sales_count.next
        end
        @report[:sales] << { user: { id: user.id, name: user.short_name }, sum: sum, count: user_sales.count, sales: user_sales_hash }
      end
    end
    @report[:sales_sum] = sales_sum
    @report[:sales_count] = sales_count
  end

end
