class RemnantsReportMailingJob < ActiveJob::Base
  queue_as :reports
  sidekiq_options retry: 5

  def perform
    report = FewRemnantsReport.new(kind: :spare_parts)
    report.call
    ReportsMailer.few_remnants(report).deliver_now
  end
end
