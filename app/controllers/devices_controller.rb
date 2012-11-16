class DevicesController < ApplicationController
  #before_filter :store_location
  helper_method :sort_column, :sort_direction
  autocomplete :device_type, :name, full: true
  autocomplete :client, :phone_number, full: true, extra_data: [:name], display_value: :name_phone
  
  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.search params
    
    if params.has_key? :sort and params.has_key? :direction
      @devices = @devices.order(sort_column + ' ' + sort_direction)
    else
      @devices = @devices.ordered
    end
    @devices = @devices.page params[:page]
    
    respond_to do |format|
      format.html
      format.json { render json: @devices }
      format.js { render 'shared/index' }
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    @device = Device.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @device }
    end
  end

  # GET /devices/new
  # GET /devices/new.json
  def new
    @device = Device.new
    #@device.device_tasks.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @device }
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id])
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(params[:device])

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render json: @device, status: :created, location: @device }
      else
        format.html { render action: "new" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /devices/1
  # PUT /devices/1.json
  def update
    @device = Device.find(params[:id])

    respond_to do |format|
      if @device.update_attributes(params[:device])
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device = Device.find(params[:id])
    @device.destroy

    respond_to do |format|
      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def sort_column
    Device.column_names.include?(params[:sort]) ? params[:sort] : ''
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
  
end
