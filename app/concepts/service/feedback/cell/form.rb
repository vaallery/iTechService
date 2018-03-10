module Service
  module Feedback::Cell
    class Form < BaseCell
      self.translation_path = 'service/feedback.form'

      private

      include FormCell

      delegate :human_attribute_name, to: :'Service::Feedback'
      property :details, :ticket_number, :service_job

      def url
        service_feedback_path(model)
      end

      def submit_label
        'Перенести'
      end

      def postpone_button
        link_to t('.postpone'), postpone_service_feedback_path(model.id), method: :put, remote: true,
                class: 'btn btn-warning'
      end

      def attribute_presentation(attr_name)
        content_tag :div, class: 'control-group' do
          content_tag(:label, human_attribute_name(attr_name), class: 'control-label') +
          content_tag(:div, send(attr_name), class: 'controls')
        end
      end

      def schedule_start
        time = 1.day.from_now.change(hour: 10)
        time.strftime '%d.%m.%Y %H:%M'
      end

      def schedule_end
        time = Feedback.max_delay_hours_for_job(service_job).hours.from_now
        time.strftime '%d.%m.%Y %H:%M'
      end

      def schedule_on_label
        t '.schedule_on'
      end

      def schedule_on_help_text
        t '.schedule_on_help', max_value: schedule_end
      end

      def device
        link_to service_job.presentation, service_job
      end

      def client
        service_job.client_presentation
      end

      def previous_feedbacks
        return if service_job.inactive_feedbacks.empty?

        content_tag(:div, class: 'previous-feedbacks well well-small') do
          service_job.inactive_feedbacks.map do |feedback|
            content_tag :p, feedback.details
          end.join
        end
      end
    end
  end
end
