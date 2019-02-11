class ReportsMailer < ApplicationMailer
  layout 'mailer'

  def few_remnants(report)
    @report = report
    mail to: 'mail@example.com', subject: I18n.t("reports.#{report.name}.title")
  end
end
