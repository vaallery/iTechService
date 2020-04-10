class DeviceTasksController < ApplicationController
  respond_to :js

  def edit
    @device_task = find_record DeviceTask
    render 'shared/show_modal_form'
  end

  def update
    @device_task = find_record DeviceTask
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
