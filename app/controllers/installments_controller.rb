class InstallmentsController < ApplicationController
  load_and_authorize_resource

  def index
    @installments = Installment.all

    respond_to do |format|
      format.html
      format.json { render json: @installments }
    end
  end

  def show
    @installment = Installment.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @installment }
    end
  end

  def new
    @installment = Installment.new

    respond_to do |format|
      format.html
      format.json { render json: @installment }
    end
  end

  def edit
    @installment = Installment.find(params[:id])
  end

  def create
    @installment = Installment.new(params[:installment])

    respond_to do |format|
      if @installment.save
        format.html { redirect_to @installment, notice: 'Installment was successfully created.' }
        format.json { render json: @installment, status: :created, location: @installment }
        format.js { render 'shared/close_modal_form' }
      else
        format.html { render action: "new" }
        format.json { render json: @installment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    @installment = Installment.find(params[:id])

    respond_to do |format|
      if @installment.update_attributes(params[:installment])
        format.html { redirect_to @installment, notice: 'Installment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @installment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @installment = Installment.find(params[:id])
    @installment.destroy

    respond_to do |format|
      format.html { redirect_to installments_url }
      format.json { head :no_content }
    end
  end
end
