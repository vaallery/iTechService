class PaymentsController < ApplicationController
  authorize_resource

  def index
    @payments = Payment.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end

  def show
    @payment = Payment.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @payment = Payment.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @payment = Payment.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @payment = Payment.new(params[:payment])
    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @payment = Payment.find(params[:id])
    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
      else
        format.html { render 'form' }
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
