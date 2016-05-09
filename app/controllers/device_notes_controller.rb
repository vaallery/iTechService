class DeviceNotesController < ApplicationController
  load_and_authorize_resource only: [:new, :create]

  def index
    @service_job = ServiceJob.find params[:service_job_id]
    @device_notes = @service_job.device_notes.newest_first
    @device_note = @service_job.device_notes.build user_id: current_user.id
    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
    end
  end

  def new
    @service_job = ServiceJob.find params[:service_job_id]
    @device_note = @service_job.device_notes.build user_id: current_user.id
    respond_to do |format|
      format.js
    end
  end

  def create
    @service_job = ServiceJob.find params[:service_job_id]
    @device_note = @service_job.device_notes.build params[:device_note]
    @device_note.user = current_user
    respond_to do |format|
      if @device_note.save
        format.js
      else
        # format.js { render 'show_form' }
        format.js { render nothing: true }
      end
    end
  end

end
