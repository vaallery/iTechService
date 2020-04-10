class OrdersController < ApplicationController
  helper_method :sort_column, :sort_direction
  skip_before_action :authenticate_user!, :set_current_user, only: :check_status
  skip_after_action :verify_authorized, only: [:check_status, :device_type_select]

  def index
    authorize Order
    if current_user.technician? or params[:kind] == 'spare_parts'
      @orders = policy_scope(Order).technician_orders.search(params)
    elsif current_user.marketing? or params[:kind] == 'not_spare_parts'
      @orders = policy_scope(Order).marketing_orders.search(params)
    else
      @orders = policy_scope(Order).search(params)
    end

    if params.has_key?(:sort) and params.has_key?(:direction)
      @orders = @orders.reorder("orders.#{sort_column} #{sort_direction}")
    else
      @orders = @orders.newest.by_status
    end

    @orders = @orders.page(params[:page]) if params[:status].present?

    respond_to do |format|
      format.html
      format.js { render 'shared/index' }
      format.json { render json: @orders }
    end
  end

  def show
    @order = find_record(Order.includes(:notes))

    respond_to do |format|
      format.html
      format.json { render json: @order }
      format.pdf do
        pdf = OrderPdf.new @order, view_context
        filename = "order_#{@order.number}.pdf"
        filepath = "#{Rails.root.to_s}/tmp/pdf/#{filename}"
        pdf.render_file filepath
        PrinterTools.print_file filepath, printer: @order.department.printer
        send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def new
    @order = authorize Order.new(status: 'new')

    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def edit
    @order = find_record Order
  end

  def create
    @order = authorize Order.new(params[:order])

    respond_to do |format|
      if @order.save
        OrdersMailer.notice(@order.id).deliver_later
        format.html { redirect_to orders_url, notice: t('orders.created') }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @order = find_record Order

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to orders_url, notice: t('orders.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = find_record Order
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  def history
    order = find_record Order
    @records = order.history_records
    render 'shared/show_history'
  end

  def check_status
    @order = policy_scope(Order).find_by_number(params[:ticket_number])

    respond_to do |format|
      if @order.present?
        format.js { render 'information' }
        format.json { render text: "orderStatus({'status':'#{@order.status_for_client}'})" }
      else
        format.js { render t('orders.not_found') }
        format.json { render js: "orderStatus({'status':'not_found'})" }
      end
    end
  end

  def device_type_select
    if params[:device_type_id].blank?
      render 'device_type_refresh'
    else
      @device_type = DeviceType.find(params[:device_type_id])
      render 'device_type_select'
    end
  end

  private

  def sort_column
    Order.column_names.include?(params[:sort]) ? params[:sort] : ''
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end
end
