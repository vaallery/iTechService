module Api
  module V1

    class DevicesController < Api::BaseController
      load_and_authorize_resource

      def show
        respond_with @device
      end

      def update
        if (location = params[:move]).present?
          if Location.respond_to? location+'_id'
              if @device.update_attributes location_id: Location.send(location+'_id')
                render json: @device
              else
                render json: {error: @device.errors}
              end
            else
              render json: {error: t('devices.errors.invalid_action')}
          end
        else
          render json: {error: t('devices.errors.no_action')}
        end
      end

    end

  end
end
