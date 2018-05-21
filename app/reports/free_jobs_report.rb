class FreeJobsReport < BaseReport
  def call
    result[:users] = []
    free_jobs = Service::FreeJob.joins(:performer, :task).where(performed_at: period)
    users_free_jobs = free_jobs.order('count_id desc').group(:performer_id).count(:id).map do |performer_id, free_jobs_qty|
      user = User.find_by(id: performer_id)
      user_free_jobs = free_jobs.where(performer_id: performer_id)

      free_tasks = user_free_jobs.order('count_id desc').group(:task_id).count(:id).transform_keys do |task_id|
        free_task = Service::FreeTask.find_by(id: task_id)
        free_task.name
      end

      {name: user.short_name, qty: free_jobs_qty, free_tasks: free_tasks}
    end
    result[:users] = users_free_jobs
    result[:total] = free_jobs.count
    result
  end
end
