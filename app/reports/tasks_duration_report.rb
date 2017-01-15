class TasksDurationReport < BaseReport

  def call
    result[:tasks_durations] = []
    Task.find_each do |task|
      task_durations = []
      device_tasks = []
      HistoryRecord.service_jobs.movements_to(task.location_id).in_period(period).each do |hr|
        moved_at = hr.created_at
        durations = []
        hr.object.device_tasks.done.where(task_id: task.id).each do |dt|
          done_at = dt.done_at
          dt_duration = ((done_at - moved_at).to_i/60).round
          durations << dt_duration
          device_tasks << {service_job: dt.service_job_presentation, service_job_id: dt.service_job.id, moved_at: moved_at, done_at: done_at, duration: dt_duration, moved_by: hr.user_name, done_by: dt.performer_name, device_location: dt.service_job.location_name}
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
end