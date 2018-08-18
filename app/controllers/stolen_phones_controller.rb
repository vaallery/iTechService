class StolenPhonesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    @stolen_phones = StolenPhone.search params
    @stolen_phones = @stolen_phones.page params[:page]

    respond_to do |format|
      format.html
      format.js { render 'shared/index' }
      format.json { render json: @stolen_phones }
    end
  end

  def show
    @comments = @stolen_phone.comments
    respond_to do |format|
      format.html
    end
  end

  def new
    @stolen_phone = StolenPhone.new

    respond_to do |format|
      format.html
      format.json { render json: @stolen_phone }
    end
  end

  def edit
    @stolen_phone = StolenPhone.find(params[:id])
  end

  def create
    @stolen_phone = StolenPhone.new
    comment = params[:stolen_phone].delete(:comment)
    @stolen_phone.assign_attributes(params[:stolen_phone])

    respond_to do |format|
      if @stolen_phone.save
        @stolen_phone.comments.create content: comment if comment.present?
        format.html { redirect_to stolen_phones_url, notice: t('stolen_phones.created') }
        format.json { render json: @stolen_phone, status: :created, location: @stolen_phone }
      else
        format.html { render action: "new" }
        format.json { render json: @stolen_phone.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @stolen_phone = StolenPhone.find(params[:id])

    respond_to do |format|
      if @stolen_phone.update_attributes(params[:stolen_phone])
        format.html { redirect_to stolen_phones_url, notice: t('stolen_phones.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stolen_phone.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stolen_phone = StolenPhone.find(params[:id])
    @stolen_phone.destroy

    respond_to do |format|
      format.html { redirect_to stolen_phones_url }
      format.json { head :no_content }
    end
  end
end
