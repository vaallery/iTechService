class OrdersController < ApplicationController
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource
  skip_load_resource only: [:index, :history]

  def index
    @orders = Order.search params

    if params.has_key? :sort and params.has_key? :direction
      @orders = @orders.reorder 'devices.'+sort_column + ' ' + sort_direction
    end
    @orders = @orders.ordered.page params[:page]

    respond_to do |format|
      format.html
      format.js { render 'shared/index' }
      format.json { render json: @orders }
    end
  end

  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def new
    @order = Order.new(customer_type: 'User', customer_id: current_user.id, status: 'new')

    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_url, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to orders_url, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end


  def history
    order = Order.find params[:id]
    @records = order.history_records
    render 'shared/show_history'
  end

  private

  def sort_column
    Order.column_names.include?(params[:sort]) ? params[:sort] : ''
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

end
