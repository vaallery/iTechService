module Api
  module V1

    class ProductsController < Api::BaseController
      skip_before_filter :authenticate_user!, only: [:remnants]
      load_and_authorize_resource except: :remnants

      def index
        respond_with @products
      end

      def show
        respond_with @product
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