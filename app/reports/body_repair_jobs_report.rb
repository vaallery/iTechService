class BodyRepairJobsReport < BaseReport
  def call
    repair_tasks = RepairTask.includes(:device_task, repair_service: :repair_group)
                     .in_department(department)
                     .where(device_tasks: {done_at: period, done: 1}, repair_services: {is_body_repair: true})

    repair_tasks.each do |repair_task|
      if repair_task.repair_service.present?
        repair_group_id = (repair_task.repair_group.try(:id) || '-').to_s
        repair_group_name = repair_task.repair_group.try(:name) || '-'
        repair_service_id = repair_task.repair_service_id || '-'
        repair_service_name = repair_task.name || '-'
        job = {id: repair_task.id, price: repair_task.price, parts_cost: repair_task.parts_cost, margin: repair_task.margin, device_id: repair_task.service_job.id, service_job_presentation: repair_task.service_job.presentation}
        
        if result[repair_group_id].present?
          if result[repair_group_id][:services][repair_service_id].is_a? Hash
            result[repair_group_id][:jobs_qty] = result[repair_group_id][:jobs_qty] + 1
            result[repair_group_id][:services][repair_service_id][:jobs_qty] = result[repair_group_id][:services][repair_service_id][:jobs_qty] + 1
            result[repair_group_id][:services][repair_service_id][:jobs_sum] = result[repair_group_id][:services][repair_service_id][:jobs_sum] + repair_task.margin
            result[repair_group_id][:services][repair_service_id][:jobs] << job
          else
            result[repair_group_id][:jobs_qty] = result[repair_group_id][:jobs_qty] + 1
            result[repair_group_id][:services_qty] = result[repair_group_id][:services_qty] + 1
            result[repair_group_id][:services][repair_service_id] = {name: repair_service_name, jobs_qty: 1, jobs_sum: repair_task.margin, jobs: [job]}
          end
        else
          result[repair_group_id] = {name: repair_group_name, services_qty: 1, jobs_qty: 1, services: {repair_service_id => {name: repair_service_name, jobs_qty: 1, jobs_sum: repair_task.margin, jobs: [job]}}}
        end
      end
    end
    result
  end
end