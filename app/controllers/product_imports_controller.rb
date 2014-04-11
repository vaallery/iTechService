class ProductImportsController < ApplicationController

  def new
    @product_import = ProductImport.new
  end

  def create
    Delayed::Job.enqueue ProductImportJob.new params_for_job
    redirect_to new_product_import_path, notice: 'Products import performed...'
  end

  private

  def params_for_job
    if (import_params = params[:product_import]).present?
      [:file, :prices_file, :barcodes_file].each { |f| import_params[f] = FileLoader.rename_uploaded_file(import_params[f]) if import_params[f].present? }
      import_params
    else
      {}
    end
  end

end