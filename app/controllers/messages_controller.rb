class MessagesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index]

  def index
    @messages = Message.newest
    unless params[:range] == 'all'
      @messages = @messages.today
    end

    respond_to do |format|
      format.html
      format.json { render json: @messages }
    end
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: t('chat.created') }
        format.json { render json: @message, status: :created, location: @message }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
end
