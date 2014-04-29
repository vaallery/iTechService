class DataSyncController < ApplicationController

  def new
    respond_to do |format|
      if Department.current.is_main? and current_user.able_to?(:sync_data)
        format.html
      else
        redirect_to root_path, error: 'Access denied'
      end
    end
  end

  def perform
    if Department.current.is_main? and current_user.able_to?(:sync_data)
      Delayed::Job.enqueue Sync::DataSyncJob.new params[:data_sync]
      redirect_to data_sync_path, notice: 'Sync performed...'
    else
      redirect_to root_path, error: 'Access denied'
    end
  end

end