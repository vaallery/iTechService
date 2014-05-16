class ImportMailer < ActionMailer::Base

  def sales_import_log(sales_import)
    @sales_import = sales_import
    @time = @sales_import.import_time
    mail to: 'kvn@itechdevs.com', subject: "Sales import log [#{l(@time, format: :long_d)}]"
  end

  def product_import_log(import_log, time, type)
    @import_log = import_log
    mail to: 'kvn@itechdevs.com, nastya@itechstore.ru', subject: t('mail.product_import_log.subject', type: type.to_s.humanize, time: l(time, format: :long))
  end

  def data_sync_log(log, time)
    @log = log
    mail to: 'kvn@itechdevs.com', subject: "Data Sync log [#{l(time, format: :long)}]"
  end

end