class RepairServicesController < ApplicationController
  authorize_resource

  def index
    @repair_groups = RepairGroup.roots.order('name asc')
    if params[:group].blank?
      @repair_services = RepairService.scoped.order('name asc')
    else
      @repair_group = RepairGroup.find params[:group]
      @repair_services = @repair_group.repair_services.order('name asc')
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @repair_service = RepairService.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @repair_service = RepairService.new params[:repair_service]
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def edit
    @repair_service = RepairService.find(params[:id])
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @repair_service = RepairService.new(params[:repair_service])
    respond_to do |format|
      if @repair_service.save
        format.html { redirect_to repair_services_path, notice: t('repair_services.created') }
      else
        format.html { render 'form' }
      end
    end
  end

  def update
    @repair_service = RepairService.find(params[:id])
    respond_to do |format|
      if @repair_service.update_attributes(params[:repair_service])
        format.html { redirect_to repair_services_path, notice: t('repair_services.udpated') }
      else
        format.html { render 'form' }
      end
    end
  end

  def mass_update
    RepairService.update_prices(params[:repair_services])
    redirect_to repair_services_path
  end

  def destroy
    @repair_service = RepairService.find(params[:id])
    @repair_service.destroy
    respond_to do |format|
      format.html { redirect_to repair_services_url }
    end
  end

  def choose
    @repair_groups = RepairGroup.roots.order('id asc')
    respond_to do |format|
      format.js
    end
  end

  def select
    @repair_service = RepairService.find params[:id]
    respond_to do |format|
      format.js
    end
  end

end
