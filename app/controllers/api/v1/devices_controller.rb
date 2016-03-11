module Api
  module V1

    class DevicesController < Api::BaseController
      load_and_authorize_resource

      def show
        respond_with @service_job
      end

      def update
        if (location = params[:move]).present?
          if Location.respond_to? location+'_id'
              if @service_job.update_attributes location_id: Location.send(location+'_id')
                render json: @service_job
              else
                render status: 403, json: {error: @service_job.errors}
              end
            else
              render status: 403, json: {error: t('api.service_jobs.errors.invalid_action')}
          end
        else
          render status: 403, json: {error: t('api.service_jobs.errors.no_action')}
        end
      end

    end

  end
end
