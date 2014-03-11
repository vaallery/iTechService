class ProductImportsController < ApplicationController

  def new
    @product_import = ProductImport.new
  end

  def create
    @product_import = ProductImport.new params[:product_import]
    if @product_import.save
      if Rails.env.production?
        ImportMailer.delay.product_import_log(@product_import)
      else
        ImportMailer.product_import_log(@product_import).deliver
      end
      render 'new', notice: 'Products imported.'
    else
      render 'new'
    end
  end

end