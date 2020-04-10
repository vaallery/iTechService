class ImportedSalesController < ApplicationController
  def index
    authorize ImportedSale
    @imported_sales = policy_scope(ImportedSale).search(params).order('sold_at desc').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.js { render 'shared/index' }
      format.json { render json: @imported_sales.any? ? @imported_sales : {message: t('devices.not_found')} }
    end
  end
end
