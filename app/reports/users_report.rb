# TODO: fix?
class UsersReport < BaseReport

  def call
    result[:users] = []
    if (received_service_jobs = ServiceJob.where(created_at: period)).present?
      received_service_jobs.group('user_id').count('id').each_pair do |key, val|
        if key.present? && (user = User.find_by(id: key)).present?
          service_jobs = received_service_jobs.where(user_id: key)
          result[:users] << {name: user.short_name, qty: val, qty_done: service_jobs.at_done(user).count, qty_archived: service_jobs.at_archive(user).count, service_jobs: service_jobs}
        end
      end
    end
    result[:service_jobs_received_count] = received_service_jobs.count
    result[:service_jobs_received_done_count] = received_service_jobs.at_done.count
    result[:service_jobs_received_archived_count] = received_service_jobs.at_archive.count
    result
  end
end