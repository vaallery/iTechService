class DashboardController < ApplicationController

  def index
    @device_tasks = DeviceTask.pending
    @device_tasks = @device_tasks.tasks_for current_user unless current_user.admin?
    respond_to do |format|
      format.html { render 'index' }
    end
  end

  def become
    if Rails.env.development?
      sign_in :user, User.find(params[:id]), bypass: true
    end
    redirect_to root_url
  end

end
