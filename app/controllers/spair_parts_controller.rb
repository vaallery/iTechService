class SpairPartsController < ApplicationController
  authorize_resource

  def index
    @spair_parts = SpairPart.all

    respond_to do |format|
      format.html
    end
  end

  # GET /spair_parts/1
  # GET /spair_parts/1.json
  def show
    @spair_part = SpairPart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @spair_part }
    end
  end

  # GET /spair_parts/new
  # GET /spair_parts/new.json
  def new
    @spair_part = SpairPart.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @spair_part }
    end
  end

  # GET /spair_parts/1/edit
  def edit
    @spair_part = SpairPart.find(params[:id])
  end

  # POST /spair_parts
  # POST /spair_parts.json
  def create
    @spair_part = SpairPart.new(params[:spair_part])

    respond_to do |format|
      if @spair_part.save
        format.html { redirect_to @spair_part, notice: 'Spair part was successfully created.' }
        format.json { render json: @spair_part, status: :created, location: @spair_part }
      else
        format.html { render action: "new" }
        format.json { render json: @spair_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /spair_parts/1
  # PUT /spair_parts/1.json
  def update
    @spair_part = SpairPart.find(params[:id])

    respond_to do |format|
      if @spair_part.update_attributes(params[:spair_part])
        format.html { redirect_to @spair_part, notice: 'Spair part was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @spair_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spair_parts/1
  # DELETE /spair_parts/1.json
  def destroy
    @spair_part = SpairPart.find(params[:id])
    @spair_part.destroy

    respond_to do |format|
      format.html { redirect_to spair_parts_url }
      format.json { head :no_content }
    end
  end
end
