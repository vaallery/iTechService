class SalesImportsController < ApplicationController

  def new
    @sales_import = SalesImport.new
  end

  def create
    @sales_import = SalesImport.new params[:sales_import]
    if @sales_import.save
      ImportMailer.sales_import_log(@sales_import).deliver
      #render 'result', notice: 'Sales imported.'
    #else
    #  render 'new'
    end
    render 'new'
  end

end