class SalesController < ApplicationController
  authorize_resource
  helper_method :sort_column, :sort_direction

  def index
    @sales = Sale.search(params).reorder(sort_column + ' ' + sort_direction).page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @sales }
      format.js { render 'shared/index' }
    end
  end

  def show
    @sale = Sale.find params[:id]
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
    @sale = Sale.find params[:id]
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @sale = Sale.new params[:sale]
    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: t('sales.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @sale = Sale.find params[:id]
    respond_to do |format|
      if @sale.update_attributes params[:sale]
        format.html { redirect_to @sale, notice: t('sales.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @sale = Sale.find params[:id]
    @sale.set_deleted
    respond_to do |format|
      format.html { redirect_to sales_url }
    end
  end

  def post
    @sale = Sale.find params[:id]
    respond_to do |format|
      if @sale.post
        format.html { redirect_to @sale, notice: t('documents.posted') }
      else
        flash.alert = @sale.errors.full_messages
        format.html { redirect_to @sale, error: t('documents.not_posted') }
      end
    end
  end

  def unpost
    @sale = Sale.find params[:id]
    respond_to do |format|
      if @sale.unpost
        format.html { redirect_to @sale, notice: t('documents.unposted') }
      else
        flash.alert = @sale.errors.full_messages
        format.html { redirect_to @sale, error: t('documents.not_unposted') }
      end
    end
  end

  private

  def sort_column
    Sale.column_names.include?(params[:sort]) ? params[:sort] : 'date'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

end
