class TechniciansJobsReport < BaseReport
  def call
    repair_tasks = RepairTask.includes(:device_task)
                     .in_department(department)
                     .where(device_tasks: {done_at: period})

    total_sum = 0
    result[:data] = {}

    repair_tasks.each do |repair_task|
      user_id = repair_task.performer.try(:id).to_s
      user_name = repair_task.performer.try(:short_name)
      job = {id: repair_task.id, name: repair_task.name, price: repair_task.price, parts_cost: repair_task.parts_cost, margin: repair_task.margin, device_id: repair_task.service_job.id, service_job_presentation: repair_task.service_job.presentation}
      if result[:data][user_id].present?
        result[:data][user_id][:jobs_qty] = result[:data][user_id][:jobs_qty] + 1
        result[:data][user_id][:jobs_sum] = result[:data][user_id][:jobs_sum] + repair_task.margin
        result[:data][user_id][:jobs] << job
      else
        result[:data][user_id] = {name: user_name, jobs_qty: 1, jobs_sum: repair_task.margin, jobs: [job]}
      end
      total_sum += repair_task.margin
    end

    result[:total_sum] = total_sum
    result
  end
end