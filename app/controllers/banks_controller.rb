class BanksController < ApplicationController
  def index
    authorize Bank
    @banks = policy_scope(Bank).all
    respond_to do |format|
      format.html
    end
  end

  def new
    @bank = authorize(Bank.new)
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @bank = find_record(Bank)
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @bank = authorize(Bank.new(params[:bank]))
    respond_to do |format|
      if @bank.save
        format.html { redirect_to banks_path, notice: t('banks.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @bank = find_record(Bank)
    respond_to do |format|
      if @bank.update_attributes(params[:bank])
        format.html { redirect_to banks_path, notice: t('banks.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @bank = find_record(Bank)
    @bank.destroy
    respond_to do |format|
      format.html { redirect_to banks_url }
    end
  end
end
