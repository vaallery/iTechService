module Api
  module V1

    class ProductsController < Api::BaseController
      skip_before_filter :authenticate, only: [:remnants]
      authorize_resource except: [:remnants]

      def index
        @products = Product.search params
        render json: @products.as_json(only: [:id, :name])
      end

      def show
        @product = Product.find params[:id]
        render json: @product.as_json(include: {items: {include: :features}})
      end

      def remnants
        if (@product = Product.find_by_code params[:id]).present?
          render json: {remnants: @product.available_quantity_by_stores}
        else
          render status: 403, json: {error: t('products.errors.not_found')}
        end
      end

      def sync
        @products = Product.goods
        render json: products_hash(@products)
      end

      private

      def products_hash(products)
        res = {}
        products.each do |product|
          res.store product.code.to_s, { price: product.retail_price, remnants: product.remnants_hash }
        end
        res
      end

    end

  end
end