class DailySalesReportMailingJob < ActiveJob::Base
  queue_as :reports
  sidekiq_options retry: 5

  def perform
    Department.where('code LIKE ?', "#{ENV['DEPARTMENT_CODE']}%").each do |department|
      report = DailySalesReport.new(department: department, date: Date.yesterday)
      report.call
      ReportsMailer.daily_sales(report).deliver_now
    end
  end
end
