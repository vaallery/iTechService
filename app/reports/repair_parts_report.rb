class RepairPartsReport < BaseReport
  def call
    result[:data] = {}
    result[:total_parts_cost] = 0
    repair_tasks = RepairTask.includes(device_task: :service_job)
                     .where(device_tasks: {done_at: period, done: 1})

    repair_tasks = repair_tasks.in_department(department) if department

    repair_tasks.each do |repair_task|
      if repair_task.repair_parts.any?
        repair_group_id = (repair_task.repair_group.try(:id) || '-').to_s
        repair_group_name = repair_task.repair_group.try(:name) || '-'
        repair_service_id = repair_task.repair_service_id || '-'
        repair_service_name = repair_task.name || '-'
        job = {id: repair_task.id, parts_cost: repair_task.parts_cost, device_id: repair_task.service_job.id, service_job_presentation: repair_task.service_job.presentation}
        result[:total_parts_cost] = result[:total_parts_cost] + repair_task.parts_cost
        if result[:data][repair_group_id].present?
          if result[:data][repair_group_id][:services][repair_service_id].is_a? Hash
            result[:data][repair_group_id][:jobs_qty] = result[:data][repair_group_id][:jobs_qty] + 1
            result[:data][repair_group_id][:services][repair_service_id][:jobs_qty] = result[:data][repair_group_id][:services][repair_service_id][:jobs_qty] + 1
            result[:data][repair_group_id][:services][repair_service_id][:jobs_sum] = result[:data][repair_group_id][:services][repair_service_id][:jobs_sum] + repair_task.parts_cost
            result[:data][repair_group_id][:services][repair_service_id][:jobs] << job
          else
            result[:data][repair_group_id][:jobs_qty] = result[:data][repair_group_id][:jobs_qty] + 1
            result[:data][repair_group_id][:services_qty] = result[:data][repair_group_id][:services_qty] + 1
            result[:data][repair_group_id][:services][repair_service_id] = {name: repair_service_name, jobs_qty: 1, jobs_sum: repair_task.parts_cost, jobs: [job]}
          end
        else
          result[:data][repair_group_id] = {name: repair_group_name, services_qty: 1, jobs_qty: 1, services: {repair_service_id => {name: repair_service_name, jobs_qty: 1, jobs_sum: repair_task.parts_cost, jobs: [job]}}}
        end
      end
    end
    result
  end
end