module Api
  module V1

    class ProductsController < Api::BaseController
      skip_before_filter :authenticate_user!, only: [:get_remnants]
      load_and_authorize_resource
      skip_authorize_resource

      def index
        respond_with @products
      end

      def show
        respond_with @product
      end

      def get_remnants
        #@product = Product.find params[:id]
        render json: {}
      end

    end

  end
end