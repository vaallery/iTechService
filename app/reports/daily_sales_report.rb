class DailySalesReport < BaseReport
  attr_accessor :department, :date

  def initialize(department: nil, date: nil, **attrs)
    @department = department || Department.current
    @date = date || Date.yesterday
    super attrs
  end

  def call
    result[:total_sum] = 0
    tasks = {}

    sales.find_each do |sale|
      sale.device_tasks.each do |device_task|
        if tasks.has_key?(device_task.task_id)
          tasks[device_task.task_id][:qty] += 1
          tasks[device_task.task_id][:sum] += device_task.cost
        else
          tasks.store(device_task.task_id, {name: device_task.name, qty: 1, sum: device_task.cost})
        end

        result[:total_sum] += device_task.cost
      end
    end

    result[:tasks] = tasks
    self
  end

  private

  def sales
    cash_shift_ids = CashShift.select(:id, :cash_drawer_id).where(cash_drawer_id: department.cash_drawer_ids).pluck(:id)

    Sale
      .includes(service_job: :device_tasks)
      .selling
      .posted
      .sold_at(date.beginning_of_day..date.end_of_day)
      .where(cash_shift_id: cash_shift_ids)
      .distinct
  end
end
