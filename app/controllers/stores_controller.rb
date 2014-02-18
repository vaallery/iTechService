class StoresController < ApplicationController
  authorize_resource

  def index
    @stores = Store.all
    respond_to do |format|
      format.html
      format.json { render json: @stores }
    end
  end

  def show
    @store = Store.find params[:id]
    @product_groups = ProductGroup.roots.search(params.merge(store_kind: @store.kind)).ordered
    @store_items = @store.store_items.search(params)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @store = Store.new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @store }
    end
  end

  def edit
    @store = Store.find params[:id]
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @store }
    end
  end

  def create
    @store = Store.new params[:store]
    respond_to do |format|
      if @store.save
        format.html { redirect_to stores_path, notice: t('stores.created') }
        format.json { render json: @store, status: :created, location: @store }
      else
        format.html { render 'form' }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @store = Store.find params[:id]
    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to stores_path, notice: t('stores.updated') }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @store = Store.find params[:id]
    @store.destroy

    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :no_content }
    end
  end

  def product_details
    store = Store.find params[:id]
    @product = Product.find params[:product_id]
    @store_items = @product.store_items.in_store store
    respond_to do |format|
      format.js
    end
  end
end
