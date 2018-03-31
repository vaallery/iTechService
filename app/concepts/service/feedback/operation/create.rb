module Service
  class Feedback::Create < BaseOperation
    step :create!
    failure :set_message!

    private

    def create!(options, params:, **)
      service_job = params[:service_job]
      scheduled_on = Feedback::MAX_DELAY_HOURS[0].hours.from_now
      log = "[#{I18n.l(Time.current, format: :long)}] #{I18n.t('service.feedback.scheduled_on', time: I18n.l(scheduled_on, format: :long))}"
      options['model'] = Feedback.create(service_job: service_job, scheduled_on: scheduled_on, log: log)
    end

    def set_message!(options, model:, **)
      options['result.message'] = model.errors.full_messages.join('. ')
    end
  end
end
