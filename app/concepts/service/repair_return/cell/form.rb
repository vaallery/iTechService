module Service
  module RepairReturn::Cell
    class Form < BaseCell
      private

      include FormCell
      include ClientsHelper

      property :service_job

      def client
        client_presentation service_job.client if service_job.present?
      end

      def device
        service_job&.presentation
      end

      def spare_parts
        model.spare_parts || []
      end

      def ticket_number
        params[:ticket_number]
      end

      def button_to_return
        button_to :return, model
      end
    end
  end
end
