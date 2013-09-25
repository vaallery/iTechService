class SalesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index, :new]

  def index
    @sales = Sale.search(params).order('sold_at desc').page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @sales }
      format.js { render 'shared/index' }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @sale }
    end
  end

  def new
    @sale = Sale.new params[:sale]

    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: t('sales.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    respond_to do |format|
      if @sale.update_attributes params[:sale]
        format.html { redirect_to @sale, notice: t('sales.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @sale.destroy

    respond_to do |format|
      format.html { redirect_to sales_url }
    end
  end

end
