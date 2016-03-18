class ImportedSalesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index, :new]

  def index
    @imported_sales = ImportedSale.search(params).order('sold_at desc').page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.js { render 'shared/index' }
      format.json { render json: @imported_sales.any? ? @imported_sales : {message: t('devices.not_found')} }
    end
  end

end
