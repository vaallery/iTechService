class ProductGroupsController < ApplicationController
  before_action :set_product_group, only: %i[show edit update destroy]
  before_action :set_option_types, only: %i[new edit create update]
  authorize_resource

  def index
    @product_groups = ProductGroup.roots.order('id asc')
    if params[:group].blank?
      @opened_product_groups = []
    else
      @current_product_group = ProductGroup.find params[:group]
      @opened_product_groups = @current_product_group.path_ids[1..-1].map { |g| "product_group_#{g}" }.join(', ')
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    @products = @product_group.products.search(params)
    if params[:form] == 'sale' and !@product_group.is_service
      @products = @products.available
    end
    if params[:choose] == 'true'
      params[:table_name] = 'products/small_table'
    end
    @products = @products.page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  def new
    @product_group = ProductGroup.new params[:product_group]

    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
      format.json { render json: @product_group }
    end
  end

  def edit
    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
      format.json { render json: @product_group }
    end
  end

  def create
    @product_group = ProductGroup.new params[:product_group]
    respond_to do |format|
      if @product_group.save
        format.js
        format.json { render json: @product_group }
      else
        format.js { render 'shared/show_modal_form' }
        format.json { render json: @product_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product_group.update_attributes(params[:product_group])
        format.js
        format.json { render json: @product_group }
      else
        format.js { render 'shared/show_modal_form' }
        format.json { render json: @product_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_group.destroy

    respond_to do |format|
      format.js { render nothing: true }
      format.json { head :no_content }
    end
  end

  private

  def set_product_group
    @product_group = ProductGroup.find params[:id]
  end

  def set_option_types
    @option_types = OptionType.includes(:option_values)
  end
end
