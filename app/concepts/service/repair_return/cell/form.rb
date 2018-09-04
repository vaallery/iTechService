module Service
  module RepairReturn::Cell
    class Form < BaseCell
      private

      include FormCell
      include ClientsHelper
      include ActiveSupport::NumberHelper

      property :service_job, :service_job_id

      def client
        link_to client_presentation(service_job.client), service_job.client if service_job.present?
      end

      def device
        link_to service_job.presentation, service_job if service_job.present?
      end

      def repair_parts
        model.repair_parts || []
      end

      def ticket_number
        params[:ticket_number]
      end

      def button_to_return
        button_to t('.return'), model, params: {service_job_id: service_job_id}, class: 'btn btn-primary'
      end
    end
  end
end
