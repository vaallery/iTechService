class ServiceJobViewingsReport < BaseReport
  ReportRecord = Struct.new(:time, :job_id, :ticket_number, :viewer)

  attr_accessor :department_id

  def call
    location_id = Location.where(code: 'done', department_id: department_id).first.id
    viewings = ServiceJobViewing.includes(:service_job, :user)
                 .where(time: period, service_jobs: {location_id: location_id})
    records = []

    result[:records] = viewings.map do |viewing|
      ReportRecord.new(
                    viewing.time,
                    viewing.service_job_id,
                    viewing.service_job.ticket_number,
                    viewing.user_presentation
      )
    end
  end

  def only_day?
    true
  end
end
