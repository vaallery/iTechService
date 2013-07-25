class ClientsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index
  skip_authorize_resource only: [:check_phone_number, :questionnaire, :autocomplete, :select2]

  def index
    @clients = Client.search params
    @clients = @clients.page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @clients }
      format.js { render 'shared/index' }
    end
  end

  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @client }
    end
  end

  def new
    @client = Client.new

    respond_to do |format|
      format.html
      format.json { render json: @client }
      format.js { render 'show_form' }
    end
  end

  def edit
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html
      format.js { render 'show_form' }
    end
  end

  def create
    @client = Client.new(params[:client])

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: t('clients.created') }
        format.js { render 'saved' }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.js { render 'show_form' }
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
        format.js { render 'saved' }
      else
        format.html { render action: 'edit' }
        format.js { render 'show_form' }
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
    @client = Client.find params[:id]
  end

end
