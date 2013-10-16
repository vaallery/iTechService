class ItemsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index]

  def index
    if params[:product_id].blank?
      @items = Item.search(params)
      @feature_types = []
      @items.each {|item| @feature_types + item.feature_types.to_a}
      @feature_types.uniq!
    else
      @product = Product.find(params[:product_id]) unless params[:product_id].blank?
      @items = @product.items.search(params)
      @feature_types = @product.feature_types
    end

    if (@form = params[:form]) == 'sale'
      @items = @items.available
    end

    if params[:choose] == 'true'
      @table_name = 'small_table'
    end

    if @items.many?
      @products = Product.where(id: @items.map{|i|i.product_id})
      @products.page(params[:page])
    end

    @items = @items.page(params[:page])

    respond_to do |format|
      if @items.one?
        @item = @items.first
        format.js { render 'products/select' }
      else
        format.html
        format.js
        format.json { render json: @items }
      end
    end
  end

  def new
    @item = Item.new

    respond_to do |format|
      format.html
      format.json { render json: @item }
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
end
