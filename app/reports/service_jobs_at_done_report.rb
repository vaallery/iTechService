class ServiceJobsAtDoneReport < BaseReport
  ReportRecord = Struct.new(:ticket_number, :client, :done_at, :device, :case, :place)

  def call
    result[:records] = []
    done_location_ids = Location.select(:id).where(code: 'done').pluck(:id)
    movements_to_done = HistoryRecord.joins('LEFT OUTER JOIN service_jobs ON service_jobs.id = history_records.object_id').service_jobs.movements_to(done_location_ids).where(service_jobs: {location_id: done_location_ids}).distinct.order(created_at: :asc)#.limit(10)

    movements_to_done.each do |movement|
      service_job = movement.object

      result[:records] << ReportRecord.new(
        service_job.ticket_number,
        service_job.client_full_name,
        movement.created_at,
        service_job.presentation,
        service_job.case_color&.name,
        service_job.location_name
      )
    end

    result
  end

  # def call2
  #   result[:records] = []
  #   done_location_ids = Location.select(:id).where(code: 'done').pluck(:id)
  #   service_jobs_at_done = ServiceJob.distinct.joins(:history_records, :client, :case_color, :location).where(service_jobs: {location_id: done_location_ids}).where(history_records: {column_name: 'location_id'}).order('history_records.created_at').limit(10)
  #
  #   service_jobs_at_done.each do |service_job|
  #     result[:records] << ReportRecord.new(
  #       service_job.ticket_number,
  #       service_job.client_full_name,
  #       service_job.moved_at,
  #       service_job.presentation,
  #       service_job.case_color&.name,
  #       service_job.location_name
  #     )
  #   end
  #
  #   result
  # end
end
