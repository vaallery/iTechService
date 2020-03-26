module Service
  module RepairReturn::Cell
    class Preview < BaseCell
      private

      include ModelCell

      def performed_at
        I18n.l model.performed_at, format: :date_time
      end

      def performer
        link_to model.performer.short_name, model.performer
      end

      def service_job
        link_to model.service_job.presentation, model.service_job
      end
    end
  end
end
