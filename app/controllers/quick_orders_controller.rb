class QuickOrdersController < ApplicationController
  authorize_resource

  def index
    @quick_orders = QuickOrder.month_ago.created_desc.page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.js { render 'shared/index' }
      format.json { render json: @quick_orders }
    end
  end

  def show
    @quick_order = QuickOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quick_order }
    end
  end

  def new
    @quick_order = QuickOrder.new

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @quick_order }
    end
  end

  def edit
    @quick_order = QuickOrder.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @quick_order }
    end
  end

  def create
    @quick_order = QuickOrder.new(params[:quick_order])

    respond_to do |format|
      if @quick_order.save
        format.html { redirect_to quick_orders_path, notice: t('quick_orders.created') }
        format.json { render json: @quick_order, status: :created, location: @quick_order }
      else
        format.html { render 'form' }
        format.json { render json: @quick_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @quick_order = QuickOrder.find(params[:id])

    respond_to do |format|
      if @quick_order.update_attributes(params[:quick_order])
        format.html { redirect_to quick_orders_path, notice: t('quick_orders.updated') }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @quick_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quick_order = QuickOrder.find(params[:id])
    @quick_order.destroy

    respond_to do |format|
      format.html { redirect_to quick_orders_url }
      format.json { head :no_content }
    end
  end
end
