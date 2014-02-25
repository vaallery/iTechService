module Report

  def self.device_types_report(period, device_type_id=nil)
    result = {device_types: []}
    result[:devices_received_count] = result[:devices_received_done_count] = result[:devices_received_archived_count] = 0
    result[:current_device_type] = DeviceType.find(device_type_id) if device_type_id.present?
    device_types = result[:current_device_type].present? ? result[:current_device_type].children : DeviceType.roots
    device_types.each do |device_type|
      device_ids = []
      device_type.descendants.each do |sub_device_type|
        if sub_device_type.is_childless?
          device_ids << sub_device_type.devices.where(created_at: period).map { |d| d.id }
        end
      end
      received_devices = Device.where id: device_ids
      qty_received = received_devices.count
      qty_done = received_devices.at_done.count
      qty_archived = received_devices.at_archive.count
      result[:device_types] << {device_type: device_type, qty: qty_received, qty_done: qty_done, qty_archived: qty_archived}
      result[:devices_received_count] += qty_received
      result[:devices_received_done_count] += qty_done
      result[:devices_received_archived_count] += qty_archived
    end
    result
  end

  def self.users_report(period)
    result = {users: []}
    if (received_devices = Device.where(created_at: period)).present?
      received_devices.group('user_id').count('id').each_pair do |key, val|
        if key.present? and (user = User.find key).present?
          devices = received_devices.where(user_id: key)
          #user_devices = devices.map{|d|{id: d.id, presentation: d.presentation}}
          result[:users] << {name: user.short_name, qty: val, qty_done: devices.at_done.count, qty_archived: devices.at_archive.count, devices: devices}
        end
      end
    end
    result[:devices_received_count] = received_devices.count
    result[:devices_received_done_count] = received_devices.at_done.count
    result[:devices_received_archived_count] = received_devices.at_archive.count
    result
  end

  def self.done_tasks_report(period)
    result = {tasks: []}
    archived_devices_ids = HistoryRecord.devices.movements_to_archive.in_period(period).collect { |hr| hr.object_id }.uniq
    result[:tasks_sum] = result[:tasks_qty] = result[:tasks_qty_free] = 0
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
        result[:tasks] << {name: task_name, sum: task_sum, qty: task_count, qty_paid: task_paid_count, qty_free: task_free_count, devices: devices}
      end
      result[:tasks_sum] = tasks.sum(:cost)
      result[:tasks_qty] = tasks.count
      result[:tasks_qty_paid] = tasks.where('cost > 0').count
      result[:tasks_qty_free] = tasks.where(cost: [0, nil]).count
    end
    result
  end

  def self.clients_report(period)
    result = {new_clients: []}
    new_clients = Client.where(created_at: period)
    new_clients.each do |client|
      client_devices = client.devices.where(created_at: period).map{|device| {id: device.id, presentation: device.presentation}}
      result[:new_clients] << {id: client.id, presentation: client.presentation, created_at: client.created_at, devices: client_devices}
    end
    result[:clients_count] = Client.count
    result[:new_clients_count] = new_clients.count
    result
  end

  def self.tasks_duration_report(period)
    result = {tasks_durations: []}
    Task.find_each do |task|
      task_durations = []
      device_tasks = []
      HistoryRecord.devices.movements_to(task.location_id).in_period(period).each do |hr|
        moved_at = hr.created_at
        durations = []
        hr.object.device_tasks.done.where(task_id: task.id).each do |dt|
          done_at = dt.done_at
          dt_duration = ((done_at - moved_at).to_i/60).round
          durations << dt_duration
          device_tasks << {device: dt.device_presentation, device_id: dt.device_id, moved_at: moved_at, done_at: done_at, duration: dt_duration, moved_by: hr.user_name, done_by: dt.performer_name, device_location: dt.device.location_name}
        end
        unless durations.empty?
          task_durations << (durations.sum/durations.size).round
        end
      end
      average_duration = task_durations.present? ? (task_durations.sum/task_durations.size).round : 0
      result[:tasks_durations] << {task_name: task.name, average_duration: average_duration, device_tasks: device_tasks}
    end
    result
  end

  def self.done_orders_report(period)
    result = {orders: []}
    done_orders = Order.done_at period
    done_orders.find_each do |order|
      result[:orders] << {order: order, done_at: order.done_at}
    end
    result[:done_orders_count] = done_orders.count
    result
  end

  def self.devices_movements_report(period)
    result = {users_mv: []}
    movements = HistoryRecord.in_period(period)
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
              devices << {moved_at: movement.created_at, created_at: device.created_at, old_location: old_location.name, new_location: new_location.name, device_id: device.id, device_presentation: device.presentation, client_id: device.client_id, client_presentation: device.client_presentation, duration: duration}
            end
          end
          avarage_duration = (user_durations.sum / user_durations.size).round
          result[:users_mv] << {user: user.short_name, avarage_duration: avarage_duration, qty: val, devices: devices}
        end
      end
    end
    result
  end

  def self.sales_report(period)
    result = {sales: []}
    sales_sum = 0
    sales_count = 0
    sales = Sale.sold_at(period)
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
        result[:sales] << { user: { id: user.id, name: user.short_name }, sum: sum, count: user_sales.count, sales: user_sales_hash }
      end
    end
    result[:sales_sum] = sales_sum
    result[:sales_count] = sales_count
    result
  end

  def self.payments_report(period)
    result = {payment_kinds: {}}
    payments = Payment.includes(:sale).where(sales: {date: period, status: 1, is_return: false})
    result[:payments_sum] = payments.sum(:value)
    result[:payments_qty] = payments.count
    Payment::KINDS.each do |kind|
      payments_of_kind = payments.where(kind: kind)
      payments_hash = %w[card credit].include?(kind) ? payments_of_kind.group(:bank_id).sum(:value).map{|r| {bank: Bank.find(r[0]).try(:name), value: r[1]}} : payments_of_kind.map(&:attributes_hash)
      result[:payment_kinds].store kind, {payments: payments_hash, sum: payments_of_kind.sum(:value), qty: payments_of_kind.count}
    end
    result
  end

  def self.salary_report
    result = {salary: []}
    users = User.active
    users.find_each do |user|
      user_salaries = []
      user_prepayments = []
      user_installments = []
      5.downto(0) do |n|
        date = n.months.ago
        period = date.beginning_of_month..date.end_of_month
        user_prepayment_details = []
        user_installment_details = []
        user_month_salaries = user.salaries.salary.issued_at period
        user_month_prepayments = user.salaries.prepayment.issued_at period
        user_month_installments = user.installments.paid_at period
        user_month_installment_plans = user.installment_plans.issued_at period

        user_salaries << { amount: user_month_salaries.sum(:amount) }

        user_month_prepayments.each do |prepayment|
          user_prepayment_details << { amount: prepayment.amount, date: prepayment.issued_at, comment: prepayment.comment }
        end
        user_prepayments << { amount: user_month_prepayments.sum(:amount), details: user_prepayment_details }

        user_month_installment_plans.find_each do |installment_plan|
          user_installment_details << { value: installment_plan.cost, date: installment_plan.issued_at, object: installment_plan.object }
        end
        user_month_installments.find_each do |installment|
          user_installment_details << { value: - installment.value, date: installment.paid_at, object: installment.object }
        end
        user_installments << { sum: user_month_installment_plans.sum(:cost) - user_month_installments.sum(:value), details: user_installment_details }

      end
      result[:salary] << { user_name: user.short_name, user_id: user.id, salaries: user_salaries, prepayments: user_prepayments, installments: user_installments }
    end
    result
  end

  def self.few_remnants_report(kind)
    result = {products: {}, stores: {}}
    products = Product.send(kind)
    stores = Store.send(kind == :goods ? :retail : :spare_parts).order('id asc')
    stores.each { |store| result[:stores].store store.id.to_s, {code: store.code, name: store.name} }
    products.each do |product|
      remnants = {}
      stores.each do |store|
        if product.quantity_threshold.present? and (qty = product.quantity_in_store(store)) <= product.quantity_threshold
          remnants.store store.id.to_s, qty
        end
      end
      result[:products].store product.id.to_s, {code: product.code, name: product.name, threshold: product.quantity_threshold, remnants: remnants} unless remnants.empty?
    end
    result
  end

end