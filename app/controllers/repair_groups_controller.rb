class RepairGroupsController < ApplicationController
  authorize_resource

  def index
    @repair_groups = RepairGroup.roots.order('id asc')
    respond_to do |format|
      format.js
    end
  end

  def show
    @repair_group = RepairGroup.find params[:id]
    @repair_services = @repair_group.repair_services
    if params[:choose] == 'true'
      params[:table_name] = 'repair_services/small_table'
    end
    respond_to do |format|
      format.js
    end
  end

  def new
    @repair_group = RepairGroup.new params[:repair_group]
    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
    end
  end

  def edit
    @repair_group = RepairGroup.find(params[:id])
    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
    end
  end

  def create
    @repair_group = RepairGroup.new(params[:repair_group])
    @repair_groups = RepairGroup.roots.order('id asc')
    respond_to do |format|
      if @repair_group.save
        format.js { render 'save' }
      else
        format.js { render 'shared/show_modal_form' }
      end
    end
  end

  def update
    @repair_group = RepairGroup.find(params[:id])
    @repair_groups = RepairGroup.roots.order('id asc')
    respond_to do |format|
      if @repair_group.update_attributes(params[:repair_group])
        format.js { render 'save' }
      else
        format.js { render 'shared/show_modal_form' }
      end
    end
  end

  def destroy
    @repair_group = RepairGroup.find(params[:id])
    @repair_group.destroy
    respond_to do |format|
      format.js { render nothing: true }
    end
  end
end
