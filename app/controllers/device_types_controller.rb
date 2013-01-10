class DeviceTypesController < ApplicationController
  load_and_authorize_resource

  def index
    @device_types = DeviceType.order('ancestry asc').page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @device_types }
    end
  end

  def create
    @device_type = DeviceType.new(params[:device_type])

    respond_to do |format|
      if @device_type.save
        format.json { render json: @device_type, status: :created, location: @device_type }
      else
        format.html { render action: "new" }
        format.json { render json: @device_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @device_type = DeviceType.find params[:id]
  end

  def update
    @device_type = DeviceType.find(params[:id])

    respond_to do |format|
      if @device_type.update_attributes(params[:device_type])
        format.js { render 'edit' }
        format.json { head :no_content }
      else
        format.js { render 'edit' }
        format.json { render json: @device_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @device_type = DeviceType.find(params[:id])
    @device_type.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
