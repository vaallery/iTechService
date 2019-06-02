module Service
  class Feedback::Postpone < BaseOperation
    step Model(Feedback, :find_by)
    failure :record_not_found!
    step Policy.Pundit(Feedback::Policy, :update?)
    failure :not_authorized!
    step :postpone!

    private

    def postpone!(model:, current_user:, **)
      if model.postpone_count < 5
        model.scheduled_on = 1.hour.from_now
        model.postpone_count += 1
      else
        model.scheduled_on = 1.day.from_now.change(hour: 10)
        model.postpone_count = 0
      end

      log = "[#{I18n.l(Time.current, format: :long)}. #{current_user.short_name}] #{I18n.t('service.feedback.postponed')}"
      model.add_log log
      model.save
    end
  end
end
