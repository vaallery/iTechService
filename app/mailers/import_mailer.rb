class ImportMailer < ApplicationMailer

  def sales_import_log(import_logs)
    @import_logs = import_logs
    mail to: recipients, subject: "Sales import log [#{l(Time.current, format: :date_time)}]"
  end

  def sales_import_error(error)
    mail to: recipients, subject: "!!! Sales import error [#{l(Time.current, format: :date_time)}]", body: error
  end

  def product_import_log(import_log, time, type)
    @import_log = import_log
    mail to: recipients, subject: t('mail.product_import_log.subject', type: type.to_s.humanize, time: l(time, format: :long))
  end

  private

  def recipients
    Setting.emails_for_sales_import
  end
end
