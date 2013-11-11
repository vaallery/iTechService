class SalesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index, :new]
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
    @sale.set_deleted

    respond_to do |format|
      format.html { redirect_to sales_url }
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
