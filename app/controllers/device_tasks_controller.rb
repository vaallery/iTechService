class DeviceTasksController < ApplicationController
  authorize_resource
  respond_to :js

  def edit
    @device_task = DeviceTask.find params[:id]
    render 'shared/show_modal_form'
  end

  def update
    @device_task = DeviceTask.find params[:id]
    operation = Service::DeviceTasks::Update.new.with_step_args(
      validate: [@device_task],
      save: [current_user],
      notify: [current_user, params]
    )

    operation.(params[:device_task]) do |m|
      m.success { |_| render('update') }
      m.failure { |_| render('shared/show_modal_form') }
    end
  end
end
