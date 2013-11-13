module Api
  module V1

    class BarcodesController < Api::BaseController
      skip_before_filter :authenticate

      def scan
        barcode_num = params[:barcode_num]
        #if barcode_num.start_with? Product::BARCODE_PREFIX
        #  if (item = Item.find_by_barcode_num barcode_num).present?
        #    render json: {product: item}
        #  else
        #    render status: 403, json: {error: t('errors.nothing_found')}
        #  end
        #else
          barcode_num = barcode_num.gsub!(/^0+/, '').chop if barcode_num.length == 13
          if (device = Device.find_by_ticket_number barcode_num).present?
            render json: {device: device}
          else
            render status: 403, json: {error: t('errors.nothing_found')}
          end
        #end
      end

    end

  end
end
