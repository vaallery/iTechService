class PriceTypesController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: @price_types }
    end
  end

  def new
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @price_type }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @price_type }
    end
  end

  def create
    respond_to do |format|
      if @price_type.save
        format.html { redirect_to price_types_path, notice: 'Price type was successfully created.' }
        format.json { render json: @price_type, status: :created, location: @price_type }
      else
        format.html { render 'form' }
        format.json { render json: @price_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @price_type.update_attributes(params[:price_type])
        format.html { redirect_to price_types_path, notice: 'Price type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @price_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @price_type.destroy

    respond_to do |format|
      format.html { redirect_to price_types_url }
      format.json { head :no_content }
    end
  end
end
