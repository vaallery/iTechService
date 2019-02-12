class ReportsMailer < ApplicationMailer
  layout 'mailer'

  def few_remnants(report)
    @report = report
    recipients = Setting.get_value('emails_for_acts')
    mail to: recipients, subject: I18n.t("reports.#{report.name}.title")
  end
end
