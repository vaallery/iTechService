class SalesImportsController < ApplicationController

  def new
    @sales_import = SalesImport.new
  end

  def create
    Delayed::Job.enqueue SalesImportJob.new(params_for_job)
    redirect_to new_sales_import_path, notice: t('imports.enqueued')
  end

  private

  def params_for_job
    if (import_params = params[:sales_import]).present?
      import_params[:file] = FileLoader.rename_uploaded_file import_params[:file]
      import_params
    else
      {}
    end
  end

end