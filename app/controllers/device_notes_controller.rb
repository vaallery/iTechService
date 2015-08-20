class DeviceNotesController < ApplicationController
  load_and_authorize_resource only: [:new, :create]

  def index
    @device = Device.find params[:device_id]
    @device_notes = @device.device_notes.newest_first
    @device_note = @device.device_notes.build user_id: current_user.id
    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
    end
  end

  def new
    @device = Device.find params[:device_id]
    @device_note = @device.device_notes.build user_id: current_user.id
    respond_to do |format|
      format.js
    end
  end

  def create
    @device = Device.find params[:device_id]
    @device_note = @device.device_notes.build params[:device_note]
    @device_note.user = current_user
    respond_to do |format|
      if @device_note.save
        format.js
      else
        format.js { render 'shared/show_modal_form' }
      end
    end
  end

end
