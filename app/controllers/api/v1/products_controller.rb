module Api
  module V1

    class ProductsController < Api::BaseController
      skip_before_filter :authenticate, only: [:remnants]
      load_and_authorize_resource except: :remnants
      skip_load_resource only: :index

      def index
        @products = Product.search params
        respond_with @products.as_json only: [:id, :name]
      end

      def show
        respond_with @product.as_json include: {items: {include: :features}}
      end

      def remnants
        if (@product = Product.find_by_code params[:id]).present?
          render json: {remnants: @product.available_quantity_by_stores}
        else
          render status: 403, json: {error: t('products.errors.not_found')}
        end
      end

    end

  end
end