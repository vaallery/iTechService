class ServiceJobsController < ApplicationController
  include ServiceJobsHelper
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource only: [:index, :new, :edit, :create, :update, :destroy, :set_keeper]
  skip_load_resource except: [:index, :new, :edit, :create, :update, :destroy, :set_keeper]
  skip_authorize_resource only: :check_status
  skip_before_filter :authenticate_user!, :set_current_user, only: :check_status

  def index
    if params[:location].present?
      @service_jobs = ServiceJob.search(params)
    else
      @service_jobs = ServiceJob.unarchived.search(params)
    end

    if params.has_key? :sort and params.has_key? :direction
      @service_jobs = @service_jobs.reorder 'service_jobs.'+sort_column + ' ' + sort_direction
    end
    @service_jobs = @service_jobs.newest.page params[:page]
    @location_name = params[:location].present? ? Location.find(params[:location]).name : 'everywhere'# I18n.t('everywhere')
    @locations = Location.all

    respond_to do |format|
      format.html
      format.json { render json: @service_jobs }
      format.js { render 'shared/index' }
    end
  end

  def show
    if params[:find] == 'ticket'
      @service_job = ServiceJob.find_by_ticket_number(params[:id])
      respond_to do |format|
        format.js do
          if @service_job.present?
            log_service_job_show
            render 'ticket_scan'
          else
            flash.now[:error] = t('service_jobs.not_found_by_ticket', ticket: params[:id])
          end
        end
      end
    else
      @service_job = ServiceJob.includes(:device_notes).find(params[:id])
      @device_note = @service_job.device_notes.build user_id: current_user.id
      respond_to do |format|
        format.html { log_service_job_show }
        format.json do
          log_service_job_show
          render json: @service_job
        end
        format.pdf do
          if can? :print_receipt, @service_job
            filename = "ticket_#{@service_job.ticket_number}.pdf"
            if params[:print]
              pdf = TicketPdf.new @service_job, view_context
              filepath = "#{Rails.root.to_s}/tmp/pdf/#{filename}"
              pdf.render_file filepath
              PrinterTools.print_file filepath, type: :ticket, printer: @service_job.department.printer
            else
              pdf = TicketPdf.new @service_job, view_context, params[:part]
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
    @service_job = ServiceJob.new params[:service_job]
    @service_job.department_id = current_user.department_id

    respond_to do |format|
      format.html { render_form }
      format.json { render json: @service_job }
    end
  end

  def edit
    @service_job = ServiceJob.includes(:device_notes).find(params[:id])
    @device_note = DeviceNote.new user_id: current_user.id, service_job_id: @service_job.id
    log_service_job_show
    respond_to do |format|
      format.html { render_form }
      format.js { render 'shared/show_modal_form' }
    end
  end

  def create
    @service_job = ServiceJob.new(params[:service_job])

    respond_to do |format|
      if @service_job.save
        create_phone_substitution if @service_job.phone_substituted?
        Service::Feedback::Create.(service_job: @service_job)
        format.html { redirect_to @service_job, notice: t('service_jobs.created') }
        format.json { render json: @service_job, status: :created, location: @service_job }
      else
        format.html { render_form }
        format.json { render json: @service_job.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @service_job = ServiceJob.find(params[:id])
    @device_note = DeviceNote.new user_id: current_user.id, service_job_id: @service_job.id

    respond_to do |format|
      if @service_job.update_attributes(params_for_update)
        create_phone_substitution if @service_job.phone_substituted?
        Service::DeviceSubscribersNotificationJob.perform_later @service_job.id, current_user.id, params
        format.html { redirect_to @service_job, notice: t('service_jobs.updated') }
        format.json { head :no_content }
        format.js { render 'update' }
      else
        format.html { render_form }
        format.json { render json: @service_job.errors, status: :unprocessable_entity }
        format.js { render 'shared/show_modal_form' }
      end
    end
  end

  def destroy
    service_job = ServiceJob.find(params[:id])

    if service_job.repair_parts.any?
      flash.alert = t('service_jobs.errors.cannot_be_destroyed')
    else
      DeletionMailer.delay.notice({presentation: service_job.decorate.presentation, tasks: service_job.tasks.map(&:name).join(', ')}, current_user.presentation, DateTime.current)
      service_job.destroy
    end

    respond_to do |format|
      format.html { redirect_to(request.referrer || service_jobs_url) }
      format.json { head :no_content }
    end
  end

  def work_order
    respond_to do |format|
      service_job = ServiceJob.find params[:id]
      pdf = WorkOrderPdf.new service_job, view_context
      filename = "work_order_#{service_job.ticket_number}.pdf"
      format.pdf { send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline' }
    end
  end

  def completion_act
    respond_to do |format|
      service_job = ServiceJob.find params[:id]
      pdf = CompletionActPdf.new service_job, view_context
      filename = "completion_act_#{service_job.ticket_number}.pdf"
      format.pdf { send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline' }
    end
  end

  def history
    service_job = ServiceJob.find params[:id]
    @records = service_job.history_records
    render 'shared/show_history'
  end

  def task_history
    service_job = ServiceJob.find params[:service_job_id]
    device_task = DeviceTask.find params[:id]
    @records = device_task.history_records
    render 'shared/show_history'
  end

  # TODO
  def device_type_select
    if params[:device_type_id].blank?
      render 'device_type_refresh'
    else
      @device_type = DeviceType.find params[:device_type_id]
      render 'device_type_select'
    end
  end

  def check_status
    @service_job = ServiceJob.find_by_ticket_number params[:ticket_number]

    respond_to do |format|
      if @service_job.present?
        format.js { render 'information' }
        format.json { render text: "deviceStatus({'status':'#{@service_job.status}'})" }
      else
        format.js { render t('service_jobs.not_found') }
        format.json { render js: "deviceStatus({'status':'not_found'})" }
      end
    end
  end

  def check_imei
    item = Item.find(params[:item_id])
    msg = ''
    if item.imei.present?
      stolen_phone = StolenPhone.by_imei(item.imei).first
      msg = t('service_jobs.phone_stolen') if stolen_phone.present?
    end
    render json: {present: stolen_phone.present?, msg: msg}
  end

  # TODO
  def device_select
    @service_job = ServiceJob.find params[:service_jobs_id]
  end

  def movement_history
    @service_job = ServiceJob.find params[:id]
  end

  def create_sale
    service_job = ServiceJob.find params[:id]
    respond_to do |format|
      if (sale = service_job.create_filled_sale).present?
        format.html { redirect_to edit_sale_path(sale) }
      else
        format.html { render nothing: true }
      end
    end
  end

  def quick_search
    @service_jobs = ServiceJob.quick_search params[:quick_search]
    respond_to do |format|
      format.js { render nothing: true if @service_jobs.count > 10 }
    end
  end

  def set_keeper
    new_keeper_id = @service_job.keeper == current_user ? nil : current_user.id
    @service_job.update_attribute :keeper_id, new_keeper_id
    respond_to do |format|
      format.js
    end
  end

  private

  def params_for_update
    allowed_params = params[:service_job]
    if allowed_params.key?(:device_tasks_attributes)
      allowed_params[:device_tasks_attributes].each do |_key, device_task_attributes|
        if device_task_attributes.key?(:id)
          device_task = DeviceTask.find(device_task_attributes[:id])
          device_task_attributes[:_destroy] = false if device_task.repair_parts.any?
        end
      end
    end
    allowed_params
  end

  def sort_column
    ServiceJob.column_names.include?(params[:sort]) ? params[:sort] : ''
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

  def log_service_job_show
    LogServiceJobShowJob.perform_later @service_job.id, current_user.id, Time.current.to_s
  end

  def create_phone_substitution
    PhoneSubstitution.create_with(issuer_id: current_user.id, issued_at: Time.current).find_or_create_by(service_job_id: @service_job.id, substitute_phone_id: @service_job.substitute_phone_id, withdrawn_at: nil)
    # PhoneSubstitution.create service_job_id: @service_job.id,
    #                          substitute_phone_id: @service_job.substitute_phone_id,
    #                          issuer_id: current_user.id,
    #                          issued_at: @service_job.created_at
  end

  def render_form
    set_job_templates
    render 'form'
  end

  def set_job_templates
    @job_templates = Service::JobTemplate.select(:field_name, :content).all.to_a.group_by(&:field_name)
  end
end
