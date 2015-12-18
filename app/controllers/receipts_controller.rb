class ReceiptsController < ApplicationController
  def new
  end

  def add_product
  end

  def print
    respond_to do |format|
      format.pdf do
        render_receipt if params[:print_receipt].present?
        render_warranty if params[:print_warranty].present?
      end
    end
  end

  private

  def render_receipt
    send_data document.receipt, filename: 'receipt.pdf', type: 'application/pdf', disposition: 'inline'
  end

  def render_warranty
    send_data document.warranty, filename: 'warranty.pdf', type: 'application/pdf', disposition: 'inline'
  end

  def document
    @document ||= PrintReceipt.(current_user.department, params[:receipt])
  end
end
