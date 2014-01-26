class BanksController < ApplicationController
  authorize_resource

  def index
    @banks = Bank.all
    respond_to do |format|
      format.html
    end
  end

  def new
    @bank = Bank.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @bank = Bank.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @bank = Bank.new(params[:bank])
    respond_to do |format|
      if @bank.save
        format.html { redirect_to @bank, notice: 'Bank was successfully created.' }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @bank = Bank.find(params[:id])
    respond_to do |format|
      if @bank.update_attributes(params[:bank])
        format.html { redirect_to @bank, notice: 'Bank was successfully updated.' }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @bank = Bank.find(params[:id])
    @bank.destroy
    respond_to do |format|
      format.html { redirect_to banks_url }
    end
  end
end
