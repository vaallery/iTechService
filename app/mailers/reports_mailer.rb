class ReportsMailer < ApplicationMailer
  layout 'mailer'

  def few_remnants(report)
    @report = report
    recipients = Setting.get_value('emails_for_acts')
    department = Department.find_by_code(ENV['DEPARTMENT_CODE'])
    mail to: recipients, subject: "[#{department.name}] #{I18n.t("reports.#{report.name}.title")}"
  end
end
