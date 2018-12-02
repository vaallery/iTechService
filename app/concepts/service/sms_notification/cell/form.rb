module Service
  module SMSNotification::Cell
    class Form < BaseCell
      self.translation_path = 'service/sms_notification/view/form'

      private

      include FormCell

      def errors
        if model.errors.any?
          content_tag :div, class: 'alert alert-error' do
            model.errors.full_messages.join('. ')
          end
        end
      end

      def button_to_dispatch
        button_to t('.dispatch'), model, class: 'btn btn-primary'
      end

      def button_to_close
        button_tag t('close'), type: :button, class: 'btn', onclick: 'App.Service.Jobs.close_sms_notification_form();'
      end

      def service_job_id
        options[:service_job_id]
      end
    end
  end
end
