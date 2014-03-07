class ProductApi < Grape::API
  version 'v1', using: :path
  before { authenticate! }

  helpers do
    def products_hash(products)
      res = {}
      products.each do |product|
        res.store product.code.to_s, { price: product.retail_price, remnants: product.remnants_hash }
      end
      res
    end
  end

  desc 'Get products remnants for shops'
  post 'products_sync' do
    authorize! :sync, Product
    products_hash Product.goods
  end

end