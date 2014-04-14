class ProductImportsController < ApplicationController

  def new
    @product_import = ProductImport.new
  end

  def create
    if params[:product_import][:store_id].present?
      Delayed::Job.enqueue ProductImportJob.new params_for_job
      redirect_to new_product_import_path, notice: 'Products import performed...'
    else
      redirect_to new_product_import_path, error: 'Store is not defined!!!'
    end
  end

  private

  def params_for_job
    # if (import_params = params).present?
    if (import_params = params[:product_import]).present?
      [:file, :prices_file, :barcodes_file].each { |f| import_params[f] = FileLoader.rename_uploaded_file(import_params[f]) if import_params[f].present? }
      import_params
    else
      {}
    end
  end

end