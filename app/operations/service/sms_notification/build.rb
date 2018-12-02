module Service
  class SMSNotification::Build < ATransaction
    map :build

    private

    def build(service_job_id:, **)
      service_job = ServiceJob.find(service_job_id)
      message = I18n.t('service.sms_notification.default_message', ticket_number: service_job.ticket_number)
      SMSNotification.new message: message
    end
  end
end
