class ProductImportJob < Struct.new(:params)

  def perform
    product_import = ProductImport.new params
    product_import.save
    ImportMailer.product_import_log(product_import).deliver
  end

  def name
    "Products import {#{params.inspect}}"
  end

end