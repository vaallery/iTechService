class CashShiftsController < ApplicationController
  authorize_resource

  def show
    @cash_shift = CashShift.find params[:id]
    respond_to do |format|
      format.pdf do
        pdf = CashShiftPdf.new @cash_shift, view_context
        filename = "cash_shift_#{@cash_shift.id}.pdf"
        send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def close
    @cash_shift = CashShift.find params[:id]
    if @cash_shift.close
      redirect_to cash_shift_path(@cash_shift, format: :pdf)
    else
      redirect_to cash_drawer_path(@cash_shift.cash_drawer)
    end
  end

end
