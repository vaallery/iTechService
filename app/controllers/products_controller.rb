class ProductsController < ApplicationController
  authorize_resource

  def index
    @product_groups = ProductGroup.roots.order('id asc')
    if params[:group].blank?
      @opened_product_groups = []
      @products = Product.search(params)
    else
      @current_product_group = ProductGroup.find params[:group]
      @opened_product_groups = @current_product_group.path_ids[1..-1].map { |g| "product_group_#{g}" }.join(', ')
      @products = @current_product_group.products.search(params)
    end

    if params[:form] == 'sale'
      @products = @products.available
    end

    @products = @products.page(params[:page])

    if params[:choose] == 'true'
      params[:table_name] = 'small_table'
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @products }
    end
  end

  def show
    @product = Product.find params[:id]
    @items = @product.items.available
    respond_to do |format|
      format.html
      format.json { render json: @product }
    end
  end

  def new
    @product = Product.new params[:product]
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @product }
    end
  end

  def edit
    @product = Product.find params[:id]
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @product = Product.new params[:product]
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: t('products.created') }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render 'form' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @product = Product.find params[:id]
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: t('products.updated') }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product = Product.find params[:id]
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def choose
    @product_groups = ProductGroup.goods.at_depth(1)
    @product = Product.find params[:product_id] if params[:product_id].present?
    params[:form_name] = 'products/choose_form'
    respond_to do |format|
      format.js
    end
  end

  def select
    @store = Store.find params[:store_id] if params[:store_id].present?
    @client = Client.find params[:client_id] if params[:client_id].present?

    if params[:product_id].present?
      @product = Product.find params[:product_id]
      if @product.feature_accounting
        @items = @product.items
        @items = @items.available if %w[sale movement_act].include? params[:form]
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

  def show_prices
    @product = Product.find params[:id]
    @product_prices = @product.prices.page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  def show_remains
    @product = Product.find params[:id]
    @stores = Store.all
    #@store_items = @product.store_items.order('store_id asc')
    respond_to do |format|
      format.js
    end
  end

  def remains_in_store
    product = Product.find params[:id]
    store = Store.find params[:store_id]
    quantity = product.quantity_in_store store
    respond_to do |format|
      format.json { render json: {quantity: quantity} }
    end
  end

  def related
    @product = Product.find params[:id]
    @related_products = @product.related_products.limit(5)
    @related_product_groups = @product.related_product_groups.limit(5)
    respond_to do |format|
      format.js
    end
  end

end
