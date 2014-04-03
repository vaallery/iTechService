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

end