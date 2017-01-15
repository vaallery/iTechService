class DoneTasksReport < BaseReport

  def call
    result[:tasks] = []
    archived_service_jobs_ids = HistoryRecord.service_jobs.movements_to_archive.in_period(period).collect { |hr| hr.object_id }.uniq
    result[:tasks_sum] = result[:tasks_qty] = result[:tasks_qty_free] = 0
    if archived_service_jobs_ids.any?
      tasks = DeviceTask.where device_id: archived_service_jobs_ids
      tasks.collect { |t| t.task_id }.uniq.each do |task_id|
        task = Task.find task_id
        task_name = task.name
        same_tasks = tasks.where(task_id: task_id)
        task_sum = same_tasks.sum(:cost)
        task_count = same_tasks.count
        task_paid_count = same_tasks.where('cost > 0').count
        task_free_count = same_tasks.where(cost: [0, nil]).count
        service_jobs = same_tasks.collect do |same_task|
          {id: same_task.service_job.id, name: same_task.service_job.type_name, cost: same_task.cost}
        end
        result[:tasks] << {name: task_name, sum: task_sum, qty: task_count, qty_paid: task_paid_count, qty_free: task_free_count, service_jobs: service_jobs}
      end
      result[:tasks_sum] = tasks.sum(:cost)
      result[:tasks_qty] = tasks.count
      result[:tasks_qty_paid] = tasks.where('cost > 0').count
      result[:tasks_qty_free] = tasks.where(cost: [0, nil]).count
    end
    result
  end
end