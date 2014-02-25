class CashDrawersController < ApplicationController
  authorize_resource

  def index
    @cash_drawers = CashDrawer.all
    respond_to do |format|
      format.html
    end
  end

  def show
    @cash_drawer = CashDrawer.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @cash_drawer = CashDrawer.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @cash_drawer = CashDrawer.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @cash_drawer = CashDrawer.new(params[:cash_drawer])
    respond_to do |format|
      if @cash_drawer.save
        format.html { redirect_to @cash_drawer, notice: 'Cash drawer was successfully created.' }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @cash_drawer = CashDrawer.find(params[:id])
    respond_to do |format|
      if @cash_drawer.update_attributes(params[:cash_drawer])
        format.html { redirect_to @cash_drawer, notice: 'Cash drawer was successfully updated.' }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @cash_drawer = CashDrawer.find(params[:id])
    @cash_drawer.destroy
    respond_to do |format|
      format.html { redirect_to cash_drawers_url }
    end
  end
end
