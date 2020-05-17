class ServiceJobViewingsReport < BaseReport
  ReportRecord = Struct.new(:time, :job_id, :ticket_number, :viewer, :sum)

  def call
    locations = Location.in_department(department).done
    viewings = ServiceJobViewing.includes(:service_job, :user)
                 .where(time: period, service_jobs: {location_id: locations})

    result[:records] = viewings.map do |viewing|
      ReportRecord.new(
                    viewing.time,
                    viewing.service_job_id,
                    viewing.service_job.ticket_number,
                    viewing.user_presentation,
                    viewing.service_job.tasks_cost
      )
    end
  end

  def only_day?
    true
  end
end
