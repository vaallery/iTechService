class ReportsMailer < ApplicationMailer
  layout 'mailer'

  def few_remnants(report)
    @report = report
    recipients = Setting.emails_for_acts
    department = Department.find_by_code(ENV['DEPARTMENT_CODE'])
    mail to: recipients, subject: "[#{department.name}] #{I18n.t("reports.#{report.name}.title")}"
  end

  def daily_sales(report)
    @result = report.result
    mail to: Setting.emails_for_sales_report,
         subject: "iTechService. Отчёт продаж день за #{I18n.l(report.date, format: :long)}"
  end
end
