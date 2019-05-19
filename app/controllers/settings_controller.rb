class SettingsController < ApplicationController
  load_and_authorize_resource

  def index
    authorize! :manage, Setting
    respond_to do |format|
      format.html
      format.json { render json: @settings }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.json { render json: @setting }
    end
  end

  def edit
  end

  def create
    respond_to do |format|
      if @setting.save
        format.html { redirect_to settings_path, notice: t('settings.created') }
        format.json { render json: @setting, status: :created, location: @setting }
      else
        format.html { render action: 'new' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @setting.update_attributes(params[:setting])
        format.html { redirect_to settings_path, notice: t('settings.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @setting.destroy

    respond_to do |format|
      format.html { redirect_to settings_url }
      format.json { head :no_content }
    end
  end
end
