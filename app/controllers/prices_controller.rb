class PricesController < ApplicationController

  load_and_authorize_resource

  def index
    @prices = Price.all

    respond_to do |format|
      format.html
      format.json { render json: @prices }
    end
  end

  def show
    @price = Price.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @price }
    end
  end

  def new
    @price = Price.new

    respond_to do |format|
      format.html
      format.json { render json: @price }
    end
  end

  def edit
    @price = Price.find(params[:id])
  end

  def create
    @price = Price.new(params[:price])

    respond_to do |format|
      if @price.save
        format.html { redirect_to prices_url, notice: 'Price was successfully created.' }
        format.json { render json: @price, status: :created, location: @price }
      else
        format.html { render action: "new" }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @price = Price.find(params[:id])

    respond_to do |format|
      if @price.update_attributes(params[:price])
        format.html { redirect_to prices_url, notice: 'Price was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @price = Price.find(params[:id])
    @price.destroy

    respond_to do |format|
      format.html { redirect_to prices_url }
      format.json { head :no_content }
    end
  end
end
