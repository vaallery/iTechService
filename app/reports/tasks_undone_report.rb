class TasksUndoneReport < BaseReport

  def call
    tasks = DeviceTask.where(device_tasks: {done_at: period, done: 2})
    tasks.each do |task|
      task_id = (task.task_id || '-').to_s
      task_name = task.name || '-'
      task = {id: task.id, device_id: task.service_job.id, service_job: task.service_job_presentation, comment: task.comment, user_comment: task.user_comment}
      if result[task_id].present?
        result[task_id][:tasks_qty] = result[task_id][:tasks_qty] + 1
        result[task_id][:tasks] << task
      else
        result[task_id] = {name: task_name, tasks_qty: 1, tasks: [task]}
      end
    end
    result
  end
end