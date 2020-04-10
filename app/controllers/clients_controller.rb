class ClientsController < ApplicationController
  skip_authorize_resource only: [:check_phone_number, :questionnaire, :autocomplete, :select]

  def index
    authorize Client
    @clients = policy_scope(Client).search(params).id_asc.page(params[:page])
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
    @client = find_record(Client.includes(:sale_items, :orders, :free_jobs, :quick_orders, service_jobs: :device_tasks))

    respond_to do |format|
      format.html
      format.json { render json: @client }
    end
  end

  def new
    @client = authorize Client.new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @client }
      format.js { render params[:form] == 'modal' ? 'shared/show_modal_form' : 'show_form' }
    end
  end

  def edit
    @client = find_record Client
    respond_to do |format|
      format.html { render 'form' }
      format.js { render params[:form] == 'modal' ? 'shared/show_modal_form' : 'show_form' }
    end
  end

  def create
    @client = authorize Client.new(params[:client])
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
    @client = find_record Client
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
    @client = find_record Client
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
    @clients = policy_scope(Client).search(params).limit(10)
  end

  def select
    @client = find_record(Client.includes(:devices))

    respond_to do |format|
      format.js
    end
  end

  def find
    @client = authorize policy_scope(Client).find_by_card_number(params[:id])

    respond_to do |format|
      format.js { render 'select' }
    end
  end

  def export
    respond_to do |format|
      format.vcf do
        file = ExportClients.call
        send_file file, filename: 'clients.vcf', type: 'application/vcf', disposition: 'inline'
      end
    end
  end
end
