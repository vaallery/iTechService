class ProductsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    @product_groups = ProductGroup.roots.order('id asc')
    if params[:group].blank?
      @opened_product_groups = []
      @products = Product.search(params).page(params[:page])
    else
      @current_product_group = ProductGroup.find params[:group]
      @current_product_group_id = @current_product_group.id
      @opened_product_groups = @current_product_group.path_ids[1..-1].map { |g| "product_group_#{g}" }.join(', ')
      @products = @current_product_group.products.search(params).page(params[:page])
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @products }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @product }
    end
  end

  def new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @product }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: t('products.created') }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to products_path, notice: t('products.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def category_select
    category = Category.find params[:category_id]
    @feature_types = category.feature_types
  end

end
