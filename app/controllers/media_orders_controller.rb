class MediaOrdersController < ApplicationController
  authorize_resource

  def index
    @media_orders = MediaOrder.order('created_at desc').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.js { render 'shared/index' }
      format.json { render json: @media_orders }
    end
  end

  def show
    @media_order = MediaOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @media_order }
    end
  end

  def new
    @media_order = MediaOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @media_order }
    end
  end

  def edit
    @media_order = MediaOrder.find(params[:id])
  end

  def create
    @media_order = MediaOrder.new(params[:media_order])

    respond_to do |format|
      if @media_order.save
        format.html { redirect_to @media_order, notice: 'Media order was successfully created.' }
        format.json { render json: @media_order, status: :created, location: @media_order }
      else
        format.html { render action: "new" }
        format.json { render json: @media_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @media_order = MediaOrder.find(params[:id])

    respond_to do |format|
      if @media_order.update_attributes(params[:media_order])
        format.html { redirect_to @media_order, notice: 'Media order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @media_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @media_order = MediaOrder.find(params[:id])
    @media_order.destroy

    respond_to do |format|
      format.html { redirect_to media_orders_url }
      format.json { head :no_content }
    end
  end
end
