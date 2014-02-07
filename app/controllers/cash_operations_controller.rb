class CashOperationsController < ApplicationController
  authorize_resource

  def index
    @cash_operations = CashOperation.all
    respond_to do |format|
      format.html
    end
  end

  def show
    @cash_operation = CashOperation.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @cash_operation = CashOperation.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @cash_operation = CashOperation.find(params[:id])
  end

  def create
    @cash_operation = CashOperation.new(params[:cash_operation])
    respond_to do |format|
      if @cash_operation.save
        format.html { redirect_to @cash_operation, notice: 'Cash operation was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @cash_operation = CashOperation.find(params[:id])
    respond_to do |format|
      if @cash_operation.update_attributes(params[:cash_operation])
        format.html { redirect_to @cash_operation, notice: 'Cash operation was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @cash_operation = CashOperation.find(params[:id])
    @cash_operation.destroy
    respond_to do |format|
      format.html { redirect_to cash_operations_url }
    end
  end
end
