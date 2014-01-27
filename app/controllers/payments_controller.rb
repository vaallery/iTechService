class PaymentsController < ApplicationController
  authorize_resource

  def index
    @sale = Sale.find params[:sale_id]
    @payments = @sale.payments
    params[:form_name] = 'payments/modal_index'
    respond_to do |format|
      format.html
      format.js { render 'shared/show_modal_form' }
    end
  end

  def show
    @payment = Payment.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @sale = Sale.find params[:sale_id]
    @payment = Payment.new params[:payment]
    respond_to do |format|
      format.html { render 'form' }
      format.js { render 'shared/show_modal_form' }
    end
  end

  def edit
    @sale = Sale.find params[:sale_id]
    @payment = Payment.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @sale = Sale.find params[:sale_id]
    @payment = @sale.add_payment params[:payment]
    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.js { render 'save' }
      else
        format.html { render 'form' }
        format.js { render 'shared/show_modal_form' }
      end
    end
  end

  def update
    @sale = Sale.find params[:sale_id]
    @payment = Payment.find(params[:id])
    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.js { render 'save' }
      else
        format.html { render 'form' }
        format.js { render 'shared/show_modal_form' }
      end
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url }
    end
  end
end
