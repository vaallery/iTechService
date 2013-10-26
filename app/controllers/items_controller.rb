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

  def show
    respond_to do |format|
      format.pdf do
        if params[:print]
          pdf = ProductTagPdf.new @item, view_context
          system 'lp', pdf.render_file(Rails.root.to_s+"/tmp/product_tag_#{@item.barcode_num}").path
        else
          pdf = ProductTagPdf.new @item, view_context, params[:type]
        end
        send_data pdf.render, filename: "product_tag_#{@item.barcode_num}", type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def new

    respond_to do |format|
      format.html
      format.json { render json: @item }
    end
  end

  def edit
    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
    end
  end

  def create
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
    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.js { render 'update' }
      else
        format.js { render 'shared/show_modal_form' }
      end
    end
  end

  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
end
