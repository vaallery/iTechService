class ProductsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index, :choose, :select]

  def index
    @product_groups = ProductGroup.roots.order('id asc')
    if params[:group].blank?
      @opened_product_groups = []
      @products = Product.search(params)
    else
      @current_product_group = ProductGroup.find params[:group]
      @current_product_group_id = @current_product_group.id
      @opened_product_groups = @current_product_group.path_ids[1..-1].map { |g| "product_group_#{g}" }.join(', ')
      @products = @current_product_group.products.search(params)
    end

    if (@form = params[:form]) == 'sale'
      @products = @products.available
    end

    @products = @products.page(params[:page])

    if params[:choose] == 'true'
      @table_name = 'small_table'
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

  def choose
    #if params[:item].present?
    #  @item = Item.find params[:item]
    #  @product = @item.product
    #  current_product_group = @product.product_group
    #  @current_product_group_id = current_product_group.id
    #  @opened_product_groups = @current_product_group.path_ids[1..-1].map { |g| "product_group_#{g}" }.join(', ')
    #  @products = @current_product_group.products.search(params).page(params[:page])
    #end
    @product_groups = ProductGroup.roots.goods
    @form = params[:form]
    respond_to do |format|
      format.js
    end
  end

  def select
    @form = params[:form]
    @store = Store.find params[:store_id] if params[:store_id].present?
    if params[:product_id].present?
      @product = Product.find params[:product_id]
      if @product.is_feature_accounting?
        @items = @product.items
        @items = @items.available if @form == 'sale'
        @items = @items.in_store(@store) if @store.present?
        @items = @items.page(params[:page])
        @feature_types = @product.feature_types
      else
        @item = @product.items.first_or_create
      end
    end

    if params[:item_id].present?
      @item = Item.find params[:item_id]
    end

    if params[:item].present?
      @item = Item.create params[:item]
    end

    respond_to do |format|
      format.js
    end
  end

  def category_select
    category = Category.find params[:category_id]
    @feature_types = category.feature_types
  end

end
