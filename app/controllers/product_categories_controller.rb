class ProductCategoriesController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: @product_categories }
    end
  end

  def new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @product_category }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    respond_to do |format|
      if @product_category.save
        format.html { redirect_to product_categories_path, notice: t('product_categories.created') }
        format.json { render json: @product_category, status: :created, location: @product_category }
      else
        format.html { render 'form' }
        format.json { render json: @product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product_category.update_attributes(params[:product_category])
        format.html { redirect_to product_categories_path, notice: t('product_categories.updated') }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_category.destroy

    respond_to do |format|
      format.html { redirect_to product_categories_url }
      format.json { head :no_content }
    end
  end
end
