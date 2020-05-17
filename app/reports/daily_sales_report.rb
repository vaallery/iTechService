class DailySalesReport < BaseReport
  attr_accessor :department, :date

  def initialize(date: nil, **attrs)
    @date = date || Date.yesterday
    super attrs
  end

  def call
    Department.find_each do |department|
      total_sum = 0
      tasks = {}

      sales.in_department(department).find_each do |sale|
        sale.device_tasks.each do |device_task|
          if tasks.has_key?(device_task.task_id)
            tasks[device_task.task_id][:qty] += 1
            tasks[device_task.task_id][:sum] += device_task.cost
          else
            tasks.store(device_task.task_id, {name: device_task.name, qty: 1, sum: device_task.cost})
          end

          total_sum += device_task.cost
        end
      end

      result.store department.name, {total_sum: total_sum, tasks: tasks}
    end

    self
  end

  private

  def sales
    Sale
      .includes(service_job: :device_tasks)
      .selling
      .posted
      .sold_at(date.beginning_of_day..date.end_of_day)
      .distinct
  end
end
