class ImportMailer < ActionMailer::Base

  def sales_import_log(sales_import)
    @sales_import = sales_import
    @time = @sales_import.import_time
    mail to: 'kvn@itechdevs.com', subject: "Sales import log [#{l(@time, format: :long_d)}]"
  end

end