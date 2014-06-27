class Report
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  NAMES = %w[device_types users devices_archived done_tasks clients tasks_duration done_orders devices_movements payments salary supply few_remnants_goods few_remnants_spare_parts repair_jobs technicians_jobs remnants sales margin]

  attr_accessor :name, :kind, :device_type, :store_id

  #alias_attribute :few_remnants_goods, :few_remnants
  #alias_attribute :few_remnants_spare_parts, :few_remnants

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  validates_presence_of :start_date, :end_date, :name

  def persisted?
    false
  end

  def save
    if name.in? NAMES
      send name
    end
  end

  def result
    @result ||= {}
  end

  def start_date=(value)
    @start_date = (value.is_a?(String) ? value.to_time(:local) : value).strftime('%d.%m.%Y')
  end

  def start_date
    @start_date ||= Time.current.strftime('%d.%m.%Y')
  end

  def end_date=(value)
    @end_date = (value.is_a?(String) ? value.to_time(:local) : value).strftime('%d.%m.%Y')
  end

  def end_date
    @end_date ||= start_date
  end

  def period
    start_date.to_time(:local).beginning_of_day..end_date.to_time(:local).end_of_day
  end

  # def start_date=(value)
  #   @start_date = value.to_time(:local).beginning_of_day
  # end
  #
  # def end_date=(value)
  #   @end_date = value.to_time(:local).end_of_day
  # end
  #
  # def start_date
  #   @start_date ||= 1.day.ago.beginning_of_day
  # end
  #
  # def end_date
  #   @end_date ||= 1.day.ago.end_of_day
  # end
  #
  # def period
  #   start_date..end_date
  # end

  private

  def device_types
    result[:device_types] = []
    result[:devices_received_count] = result[:devices_received_done_count] = result[:devices_received_archived_count] = 0
    result[:current_device_type] = DeviceType.find(device_type) if device_type.present?
    device_types = result[:current_device_type].present? ? result[:current_device_type].children : DeviceType.roots
    device_types.each do |device_type|
      device_ids = []
      if device_type.is_childless?
        device_ids << device_type.devices.where(created_at: period).map { |d| d.id }
      else
        device_type.descendants.each do |sub_device_type|
          if sub_device_type.is_childless?
            device_ids << sub_device_type.devices.where(created_at: period).map { |d| d.id }
          end
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

  def users
    result[:users] = []
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

  def done_tasks
    result[:tasks] = []
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

  def clients
    result[:new_clients] = []
    new_clients = Client.where(created_at: period)
    new_clients.each do |client|
      client_devices = client.devices.where(created_at: period).map{|device| {id: device.id, presentation: device.presentation}}
      result[:new_clients] << {id: client.id, presentation: client.presentation, created_at: client.created_at, devices: client_devices}
    end
    result[:clients_count] = Client.count
    result[:new_clients_count] = new_clients.count
    result
  end

  def tasks_duration
    result[:tasks_durations] = []
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

  def done_orders
    result[:orders] = []
    done_orders = Order.done_at period
    done_orders.find_each do |order|
      result[:orders] << {order: order, done_at: order.done_at}
    end
    result[:done_orders_count] = done_orders.count
    result
  end

  def devices_movements
    result[:users_mv] = []
    movements = HistoryRecord.in_period(period)
    movements = movements.movements_from(Location.bar.id)
    movements = movements.movements_to([Location.content.id, Location.repair.id])
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

  def devices_archived
    result[:users_mv] = []
    movements = HistoryRecord.in_period(period)
    movements = movements.movements_from(Location.bar.id)
    movements = movements.movements_to([Location.content.id, Location.repair.id])
    total_qty = 0
    if movements.any?
      movements.group('user_id').count('id').each_pair do |key, val|
        if key.present? and (user = User.find key).present?
          result[:users_mv] << {user: user.short_name, qty: val}
        else
          result[:users_mv] << {user: '?', qty: val}
        end
        total_qty += val
      end
    end
    result[:total_qty] = total_qty
    result
  end

  def sales
    result[:sales] = []
    sales_sum = 0
    sales_count = 0
    discounts_sum = 0
    sales = Sale.sold_at(period).posted.order('date asc')

    sales.selling.each do |sale|
      sale.sale_items.each do |sale_item|
        result[:sales] << {time: sale.date, product: sale_item.name, features: sale_item.features_s, quantity: sale_item.quantity, price: sale_item.price, sum: sale_item[:price]*sale_item[:quantity], discount: sale_item.discount, client_id: sale.client_id, client: sale.client_short_name, user_id: sale.user_id, user: sale.user_short_name}
        sales_count = sales_count + sale_item.quantity
        sales_sum = sales_sum + sale_item.price
        discounts_sum = discounts_sum + sale_item.discount
      end
    end

    result[:sales_count] = sales_count
    result[:sales_sum] = sales_sum
    result[:discounts_sum] = discounts_sum
    result
  end

  def payments
    result[:payment_kinds] = {}
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

  def salary
    result[:salary] = []
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

  def supply
    result[:supply_categories] = []
    supply_reports = SupplyReport.where date: period
    supplies_sum = 0
    if supply_reports.present?
      if (supplies = Supply.where supply_report_id: supply_reports.map(&:id)).any?
        supplies.group(:supply_category_id).sum('id').each_pair do |key, val|
          if key.present? and (supply_category = SupplyCategory.find(key)).present?
            category_supplies = supplies.where(supply_category_id: key)
            category_sum = category_supplies.map{|s|s.sum}.sum
            result[:supply_categories] << {name: supply_category.name, sum: category_sum, supplies: category_supplies}
            supplies_sum = supplies_sum + category_sum
          end
        end
      end
    end
    result[:supplies_sum] = supplies_sum
    result
  end

  def few_remnants_goods
    few_remnants 'goods'
  end

  def few_remnants_spare_parts
    few_remnants 'spare_parts'
  end

  def few_remnants(kind)
    result[:products] = result[:stores] = {}
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

  def repair_jobs
    repair_tasks = RepairTask.includes(:device_task).where(device_tasks: {done_at: period})
    repair_tasks.each do |repair_task|
      if repair_task.repair_service.present?
        repair_group_id = (repair_task.repair_group.try(:id) || '-').to_s
        repair_group_name = repair_task.repair_group.try(:name) || '-'
        repair_service_id = repair_task.repair_service_id || '-'
        repair_service_name = repair_task.name || '-'
        job = {id: repair_task.id, price: repair_task.price, parts_cost: repair_task.parts_cost, margin: repair_task.margin, device_id: repair_task.device.id, device_presentation: repair_task.device.presentation}
        if result[repair_group_id].present?
          if result[repair_group_id][:services][repair_service_id].present?
            result[repair_group_id][:jobs_qty] = result[repair_group_id][:jobs_qty] + 1
            result[repair_group_id][:services][repair_service_id][:jobs_qty] = result[repair_group_id][:services][repair_service_id][:jobs_qty] + 1
            result[repair_group_id][:services][repair_service_id][:jobs_sum] = result[repair_group_id][:services][repair_service_id][:jobs_sum] + repair_task.margin
            result[repair_group_id][:services][repair_service_id][:jobs] << job
          else
            result[repair_group_id][:jobs_qty] = result[repair_group_id][:jobs_qty] + 1
            result[repair_group_id][:services_qty] = result[repair_group_id][:services_qty] + 1
            result[repair_group_id][:services][repair_service_id] = {repair_service_id => {name: repair_service_name, jobs_qty: 1, jobs_sum: repair_task.margin, jobs: [job]}}
          end
        else
          result[repair_group_id] = {name: repair_group_name, services_qty: 1, jobs_qty: 1, services: {repair_service_id => {name: repair_service_name, jobs_qty: 1, jobs_sum: repair_task.margin, jobs: [job]}}}
        end
      end
    end
    # {'group_id' => {name: 'group_name', services: {'service_id' => {name: 'service_name', jobs_qty: '1', jobs_sum: '1', jobs: []}}}}
    result
  end

  def technicians_jobs
    repair_tasks = RepairTask.includes(:device_task).where(device_tasks: {done_at: period})
    repair_tasks.each do |repair_task|
      user_id = repair_task.performer.try(:id).to_s
      user_name = repair_task.performer.try(:short_name)
      job = {id: repair_task.id, name: repair_task.name, price: repair_task.price, parts_cost: repair_task.parts_cost, margin: repair_task.margin, device_id: repair_task.device.id, device_presentation: repair_task.device.presentation}
      if result[user_id].present?
        result[user_id][:jobs_qty] = result[user_id][:jobs_qty] + 1
        result[user_id][:jobs_sum] = result[user_id][:jobs_sum] + repair_task.margin
        result[user_id][:jobs] << job
      else
        result[user_id] = {name: user_name, jobs_qty: 1, jobs_sum: repair_task.margin, jobs: [job]}
      end
    end
    result
  end

  def remnants
    result[:data] = []

    store = Store.find(store_id)
    store_items = StoreItem.includes(item: {product: :product_group}).in_store(store_id).available
    product_groups = ProductGroup.except_services.arrange
    result[:data] = nested_product_groups_remnants product_groups, store_items, store

    result
  end

  def nested_product_groups_remnants(product_groups, store_items, store)
    product_groups.collect do |product_group, sub_product_groups|
      group_store_items = store_items.where('product_groups.id = ?', product_group.id)
      if (product_ids = group_store_items.collect{|si|si.product.id}).present?
        products = product_group.products.find(product_ids).collect do |product|
          product_store_items = store_items.where('products.id = ?', product.id)
          items = product_store_items.collect do |item|
            features = item.feature_accounting ? item.features_s : '---'
            {type: 'item', depth: product_group.depth+2, id: item.item_id, name: features, quantity: item.quantity, details: [], purchase_price: item.purchase_price.to_f, price: item.retail_price.to_f, sum: item.retail_price.to_f*item.quantity}
          end
          product_quantity = product_store_items.sum(:quantity)
          {type: 'product', depth: product_group.depth+1, id: product.id, name: "#{product.code} | #{product.name}", quantity: product_quantity, details: items, purchase_price: product.purchase_price.to_f, price: product.retail_price.to_f, sum: product.retail_price.to_f*product_quantity}
        end
      else
        products = []
      end
      group_quantity = store_items.where(product_groups: {id: product_group.subtree_ids}).sum(:quantity)
      {type: 'group', depth: product_group.depth, id: product_group.id, name: "#{product_group.code} | #{product_group.name}", quantity: group_quantity, details: nested_product_groups_remnants(sub_product_groups, store_items, store) + products}
    end
  end

  def margin
    result.deep_merge!({repair: {sum: 0, details: []}, service: {sum: 0, details: []}, sale: {sum: 0, details: []}, sum: 0})
    sales = Sale.posted.sold_at(period).order('date asc')

    sales.selling.each do |sale|
      sale.sale_items.each do |sale_item|
        if sale_item.is_repair?
          kind = :repair
          # if (repair_tasks = sale_item.device_task.try(:repair_tasks)).present?

          # end
        elsif sale_item.is_service
          kind = :service
        else
          kind = :sale
        end
        # details = []
        # if sale_item.is_repair?
        #   if (repair_parts = sale.try(:device).try(:repair_parts)).present?
        #     repair_parts.each do |repair_part|
        #       details << repair_part.as_json(methods: [:id, :name, :price])
        #     end
        #   end
        # else
        #   details << sale_item.as_json(methods: [:id, :name, :price, :quantity, :discount, :purchase_price, :margin])
        # end
        # result[kind][:details] = result[kind][:details] + details
        result[kind][:details] << sale_item.as_json(methods: [:id, :name, :price, :quantity, :discount, :purchase_price, :margin])
        result[kind][:sum] = result[kind][:sum] + sale_item.margin
        result[:sum] = result[:sum] + sale_item.margin
      end
    end
    result
  end

end