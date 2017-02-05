class DevicesNotArchivedReport < BaseReport

  def call
    service_jobs = ServiceJob.received_at(period)
    result[:received_qty] = service_jobs.count
    result[:archived_qty] = service_jobs.at_archive.count
    result[:not_archived_devices] = []
    service_jobs.not_at_archive.find_each do |service_job|
      result[:not_archived_devices] << {received_at: service_job.received_at, ticket_number: service_job.ticket_number, job_id: service_job.id}
    end
    result[:not_archived_qty] = service_jobs.not_at_archive.count
    result
  end
end