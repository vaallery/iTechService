class DataSyncController < ApplicationController

  def new
    respond_to do |format|
      if true # Department.current.is_main? and current_user.able_to?(:sync_data)
        format.html
      else
        redirect_to root_path, error: 'Access denied'
      end
    end
  end

  def perform
    if true # Department.current.is_main? and current_user.able_to?(:sync_data)
      if Rails.env.development?
        @data_sync_job = Sync::DataSyncJob.new(params[:data_sync])
        @data_sync_job.perform
        render 'log'
      else
        Delayed::Job.enqueue Sync::DataSyncJob.new params[:data_sync]
        redirect_to data_sync_path, notice: 'Sync performed...'
      end
    else
      redirect_to root_path, error: 'Access denied'
    end
  end

end