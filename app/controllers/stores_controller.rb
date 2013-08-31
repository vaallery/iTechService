class StoresController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: @stores }
    end
  end

  def new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @store }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @store }
    end
  end

  def create
    respond_to do |format|
      if @store.save
        format.html { redirect_to stores_path, notice: t('stores.created') }
        format.json { render json: @store, status: :created, location: @store }
      else
        format.html { render 'form' }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to stores_path, notice: t('stores.updated') }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @store.destroy

    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :no_content }
    end
  end
end
