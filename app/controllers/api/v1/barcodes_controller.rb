module Api
  module V1

    class BarcodesController < Api::BaseController

      def scan
        barcode_num = params[:barcode_num]
        if barcode_num.start_with? Product::BARCODE_PREFIX
          item = Item.find_by_barcode_num barcode_num
          #respond_with item
          render json: {product: item}
        end
      end

    end

  end
end