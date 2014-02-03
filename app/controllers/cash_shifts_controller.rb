class CashShiftsController < ApplicationController
  authorize_resource

  def show
    @cash_shift = CashShift.find params[:id]

  end

  def close
    @cash_shift = CashShift.current
    @cash_shift.sales.unposted.destroy_all
    pdf = CashShiftPdf.new @cash_shift, view_context
    filename = "cash_shift_#{@cash_shift.id}.pdf"
    system 'lp', pdf.render_file("#{Rails.root.to_s}/tmp/checks/#{filename}").path
    send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline'
  end

end
