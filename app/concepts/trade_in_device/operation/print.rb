class TradeInDevice::Print < BaseOperation
  step Policy.Pundit(TradeInDevicePolicy, :print?)
  failure :not_authorized!
  step Model(TradeInDevice, :find_by)
  failure :record_not_found!
  step :pdf!
  step :print!

  def pdf!(options, model:, **)
    options['pdf'] = TradeInDevicePdf.new(model)
  end

  def print!(options, pdf:, current_user:, **)
    pdf.render_file
    message = PrintFile.(pdf.filepath, type: :trade_in, printer: current_user.department.printer)
    options['result.message'] = message
  end
end
