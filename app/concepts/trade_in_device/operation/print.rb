class TradeInDevice::Print < BaseOperation
  step Policy.Pundit(TradeInDevice::Policy, :print?)
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
    message = PrintFile.(pdf.filepath, printer: current_user.department.printer)
    options['result.message'] = message
  end
end
