class DeviceTasksController < ApplicationController
  authorize_resource
  respond_to :js

  def edit
    @device_task = DeviceTask.find params[:id]
    render 'shared/show_modal_form'
  end

  def update
    @device_task = DeviceTask.find params[:id]
    if @device_task.update_attributes params[:device_task]
      RepairTask.return_defected_parts(params[:warranty_swap]) unless params[:warranty_swap].empty?
      render 'update'
    else
      render 'shared/show_modal_form'
    end
  end
end
