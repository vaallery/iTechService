class DiscountsController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: @discounts }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @discount }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.json { render json: @discount }
    end
  end

  def edit
  end

  def create
    respond_to do |format|
      if @discount.save
        format.html { redirect_to discounts_path, notice: t('discounts.created') }
        format.json { render json: @discount, status: :created, location: @discount }
      else
        format.html { render action: 'new' }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @discount.update_attributes(params[:discount])
        format.html { redirect_to discounts_path, notice: t('discounts.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discount.destroy

    respond_to do |format|
      format.html { redirect_to discounts_url }
      format.json { head :no_content }
    end
  end
end
