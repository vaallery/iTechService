class CarriersController < ApplicationController
  authorize_resource

  def index
    @carriers = Carrier.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @carriers }
    end
  end

  # GET /carriers/new
  # GET /carriers/new.json
  def new
    @carrier = Carrier.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @carrier }
    end
  end

  # GET /carriers/1/edit
  def edit
    @carrier = Carrier.find(params[:id])
  end

  # POST /carriers
  # POST /carriers.json
  def create
    @carrier = Carrier.new(params[:carrier])

    respond_to do |format|
      if @carrier.save
        format.html { redirect_to carriers_path, notice: 'Carrier was successfully created.' }
        format.json { render json: @carrier, status: :created, location: @carrier }
      else
        format.html { render action: "new" }
        format.json { render json: @carrier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /carriers/1
  # PUT /carriers/1.json
  def update
    @carrier = Carrier.find(params[:id])

    respond_to do |format|
      if @carrier.update_attributes(params[:carrier])
        format.html { redirect_to carriers_path, notice: 'Carrier was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @carrier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carriers/1
  # DELETE /carriers/1.json
  def destroy
    @carrier = Carrier.find(params[:id])
    @carrier.destroy

    respond_to do |format|
      format.html { redirect_to carriers_url }
      format.json { head :no_content }
    end
  end
end
