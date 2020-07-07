class AppLogoController < ApplicationController
  def edit
    authorize :app_logo
  end

  def update
    authorize :app_logo

    uploader = AppLogoUploader.new
    uploader.store!(params[:file])
    setting = Setting.find_by_name('app_logo_filename')
    setting.update(value: uploader.filename)

    redirect_to app_logo_path
  end
end
