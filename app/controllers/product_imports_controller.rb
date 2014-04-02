class ProductImportsController < ApplicationController

  def new
    @product_import = ProductImport.new
  end

  def create
    @product_import = ProductImport.new params[:product_import]
    if @product_import.save
      ImportMailer.product_import_log(@product_import).deliver
      render 'new', notice: 'Products imported.'
    else
      render 'new'
    end
  end

  def create1
    #@product_import = ProductImport.new params[:product_import]
    Delayed::Job.enqueue ProductImportJob.new(params[:product_import])
    render 'new', notice: 'Products importing...'
    #if @product_import.save
    #  if Rails.env.production?
    #    ImportMailer.delay.product_import_log(@product_import)
    #  else
    #    ImportMailer.product_import_log(@product_import).deliver
    #  end
    #  render 'new', notice: 'Products imported.'
    #else
    #  render 'new'
    #end
  end

end