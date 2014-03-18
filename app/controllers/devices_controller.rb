class DevicesController < ApplicationController
  include DevicesHelper
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource only: [:index, :new, :edit, :create, :update, :destroy]
  skip_load_resource except: [:index, :new, :edit, :create, :update, :destroy]
  skip_authorize_resource only: :check_status
  skip_before_filter :authenticate_user!, :set_current_user, only: :check_status

  def index
    if params[:location].present?
      @devices = Device.search(params)
    else
      @devices = Device.unarchived.search(params)
    end

    if params.has_key? :sort and params.has_key? :direction
      @devices = @devices.reorder 'devices.'+sort_column + ' ' + sort_direction
    end
    @devices = @devices.newest.page params[:page]
    @location_name = params[:location].present? ? Location.find(params[:location]).full_name : 'everywhere'# I18n.t('everywhere')
    @locations = Location.scoped

    respond_to do |format|
      format.html
      format.json { render json: @devices }
      format.js { render 'shared/index' }
    end
  end

  def show
    if params[:find] == 'ticket'
      @device = Device.find_by_ticket_number(params[:id])
      respond_to do |format|
        format.js do
          flash.now[:error] = t('devices.not_found_by_ticket', ticket: params[:id]) if @device.nil?
          render 'ticket_scan'
        end
      end
    else
      @device = Device.find(params[:id])
      respond_to do |format|
        format.html
        format.json { render json: @device }
        format.pdf do
          if can? :print_receipt, @device
            filename = "ticket_#{@device.ticket_number}.pdf"
            if params[:print]
              pdf = TicketPdf.new @device, view_context
              filepath = "#{Rails.root.to_s}/tmp/pdf/#{filename}"
              pdf.render_file filepath
              PrinterTools.print_file filepath, :ticket
            else
              pdf = TicketPdf.new @device, view_context, params[:part]
            end
            send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline'
          else
            render nothing: true
          end
        end
      end
    end
  end

  def new
    @device = Device.new params[:device]

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @device }
    end
  end

  def edit
    @device = Device.find(params[:id])

    respond_to do |format|
      format.html { render 'form' }
      format.js { render 'shared/show_modal_form' }
    end
  end

  def create
    @device = Device.new(params[:device])

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: t('devices.created') }
        format.json { render json: @device, status: :created, location: @device }
      else
        format.html { render 'form' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @device = Device.find(params[:id])

    respond_to do |format|
      if @device.update_attributes(params[:device])
        format.html { redirect_to @device, notice: t('devices.updated') }
        format.json { head :no_content }
        format.js { render 'update' }
      else
        format.html { render 'form' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
        format.js { render 'shared/show_modal_form' }
      end
    end
  end

  def destroy
    @device = Device.find(params[:id])
    DeletionMailer.delay.notice({presentation: @device.presentation, tasks: @device.tasks.map(&:name).join(', ')}, current_user.presentation, DateTime.current)
    @device.destroy

    respond_to do |format|
      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end
  
  def history
    device = Device.find params[:id]
    @records = device.history_records
    render 'shared/show_history'
  end
  
  def task_history
    device = Device.find params[:device_id]
    device_task = DeviceTask.find params[:id]
    @records = device_task.history_records
    render 'shared/show_history'
  end

  def device_type_select
    if params[:device_type_id].blank?
      render 'device_type_refresh'
    else
      @device_type = DeviceType.find params[:device_type_id]
      render 'device_type_select'
    end
  end

  def check_status
    @device = Device.find_by_ticket_number params[:ticket_number]

    respond_to do |format|
      if @device.present?
        format.js { render 'information' }
        format.json { render text: "deviceStatus({'status':'#{@device.status}'})" }
      else
        format.js { render t('devices.not_found') }
        format.json { render js: "deviceStatus({'status':'not_found'})" }
      end
    end
  end

  def check_imei
    stolen_phone = StolenPhone.find_by_imei params[:imei_q]
    msg = stolen_phone.present? ? t('devices.phone_stolen') : ''
    render json: {present: stolen_phone.present?, msg: msg}
  end

  def device_select
    @device = Device.find params[:device_id]
  end

  def movement_history
    @device = Device.find params[:id]
  end

  def create_sale
    device = Device.find params[:id]
    respond_to do |format|
      if (sale = device.create_filled_sale).present?
        format.html { redirect_to edit_sale_path(sale) }
      else
        format.html { render nothing: true }
      end
    end
  end

  private
  
  def sort_column
    Device.column_names.include?(params[:sort]) ? params[:sort] : ''
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

  def generate_barcode_to(pdf, num)
    #require 'barby'
    require 'barby/barcode/ean_13'
    require 'barby/outputter/prawn_outputter'
    require 'barby/outputter/pdfwriter_outputter'

    code = '0'*(12-num.length) + num
    code = Barby::EAN13.new code
    out = Barby::PrawnOutputter.new code
    out.to_pdf document: pdf
  end

end
