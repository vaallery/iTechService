class RepairersReport < BaseReport
  def call
    repair_tasks = RepairTask.includes(:device_task)
                     .in_department(department)
                     .where.not(repairer_id: nil)
                     .where(device_tasks: {done_at: period})

    result[:data] = {}

    repair_tasks.each do |repair_task|
      repairer_id = repair_task.repairer_id
      user_name = repair_task.repairer&.presentation
      job = {id: repair_task.id, name: repair_task.name, device_id: repair_task.service_job.id, service_job_presentation: repair_task.service_job.presentation}
      if result[:data].key? repairer_id
        result[:data][repairer_id][:jobs_qty] = result[:data][repairer_id][:jobs_qty] + 1
        result[:data][repairer_id][:jobs] << job
      else
        result[:data].store repairer_id, {name: user_name, jobs_qty: 1, jobs: [job]}
      end
    end

    result
  end
end