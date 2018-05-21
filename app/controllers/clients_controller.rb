class ClientsController < ApplicationController
  authorize_resource
  skip_authorize_resource only: [:check_phone_number, :questionnaire, :autocomplete, :select]

  def index
    @clients = Client.search(params).id_asc
    @clients = @clients.page params[:page]
    if params[:search] == 'true'
      params[:table_name] = 'table_small'
      params[:form_name] = 'search_form'
    end
    respond_to do |format|
      format.html
      format.json { render json: @clients }
      format.js { render (params[:search] == 'true' ? 'shared/show_modal_form' : 'shared/index') }
    end
  end

  def show
    @client = Client.includes(:sale_items, :orders, :free_jobs, :quick_orders, service_jobs: :device_tasks)
                .find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @client }
    end
  end

  def new
    @client = Client.new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @client }
      format.js { render params[:form] == 'modal' ? 'shared/show_modal_form' : 'show_form' }
    end
  end

  def edit
    @client = Client.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
      format.js { render params[:form] == 'modal' ? 'shared/show_modal_form' : 'show_form' }
    end
  end

  def create
    @client = Client.new(params[:client])
    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: t('clients.created') }
        format.js { render params[:form] == 'modal' ? 'select' : 'saved' }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render 'form' }
        format.js { render params[:form] == 'modal' ? 'shared/show_modal_form' : 'show_form' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @client = Client.find(params[:id])
    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to @client, notice: t('clients.updated') }
        format.json { head :no_content }
        format.js { render params[:form] == 'modal' ? 'select' : 'saved' }
      else
        format.html { render 'form' }
        format.js { render params[:form] == 'modal' ? 'shared/show_modal_form' : 'show_form' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  def check_phone_number
    number = params[:number]
    @number = PhoneTools.convert_phone number
    respond_to do |format|
      format.js
    end
  end

  def questionnaire
    pdf = QuestionnairePdf.new view_context, params[:client]
    send_data pdf.render, filename: 'anketa.pdf', type: 'application/pdf', disposition: 'inline'
  end

  def autocomplete
    @clients = Client.search(params).limit(10)
  end

  def select
    @client = Client.includes(:devices).find(params[:id])
    # @devices = @client.devices
    respond_to do |format|
      format.js
    end
  end

  def find
    @client = Client.find_by_card_number params[:id]
    respond_to do |format|
      format.js { render 'select' }
    end
  end

  def export
    file = ExportClients.call
    respond_to do |format|
      format.vcf { send_file file, filename: 'clients.vcf', type: 'application/vcf', disposition: 'inline' }
    end
  end
end
