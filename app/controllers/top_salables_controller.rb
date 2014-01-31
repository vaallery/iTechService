class TopSalablesController < ApplicationController
  authorize_resource

  def index
    @top_salables = TopSalable.ordered
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @top_salable = TopSalable.find params[:id]
    @top_salables = @top_salable.salable.products if @top_salable.salable.is_a? ProductGroup
    respond_to do |format|
      format.js { render 'index' }
    end
  end

  def new
    @top_salable = TopSalable.new params[:top_salable]
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @top_salable = TopSalable.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @top_salable = TopSalable.new(params[:top_salable])
    respond_to do |format|
      if @top_salable.save
        format.html { redirect_to top_salables_path, notice: t('top_salables.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @top_salable = TopSalable.find(params[:id])
    respond_to do |format|
      if @top_salable.update_attributes(params[:top_salable])
        format.html { redirect_to top_salables_path, notice: t('top_salables.updated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @top_salable = TopSalable.find(params[:id])
    @top_salable.destroy
    respond_to do |format|
      format.html { redirect_to top_salables_url }
    end
  end
end
