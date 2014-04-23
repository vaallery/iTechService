class CasePicturesController < ApplicationController
  # authorize_resource

  def index
    respond_to do |format|
      format.html
    end
  end

  def new

  end

  def create
    if (file = params[:file]).present?
      filepath = file.path
      pdf = CasePicturePdf.new filepath, params[:countour]
      send_data pdf.render, filename: 'case_picture', type: 'application/pdf', disposition: 'inline'
    else
      render nothing: true
    end
    # respond_to do |format|
    #   format.html
    # end
  end

end