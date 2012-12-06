class DashboardController < ApplicationController
  
  def index
    @device_tasks = DeviceTask.pending.tasks_for(current_user)

    respond_to do |format|
      format.html
    end
  end

end
