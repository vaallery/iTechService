module Service
  class Feedback::Update < BaseOperation
    class Present < BaseOperation
      step Model(Feedback, :find_by)
      failure :record_not_found!
      step Policy.Pundit(Feedback::Policy, :update?)
      failure :not_authorized!
      step Contract.Build(constant: Feedback::Contract::Update)
    end

    step Nested(Present)
    step Contract.Validate(key: :service_feedback)
    failure :contract_invalid!
    step Contract.Persist(method: :sync)
    step :reschedule!
    step :persist!

    private

    def reschedule!(params:, model:, **)
      return true if params[:schedule_on].blank?
      scheduled_on = params[:schedule_on].to_datetime
      max_schedule = Feedback.max_delay_hours_for_job(model.service_job).hours.from_now
      scheduled_on = max_schedule if scheduled_on > max_schedule
      Feedback.create service_job: model.service_job, scheduled_on: scheduled_on
    end

    def persist!(model:, **)
      model.scheduled_on = nil
      model.save
    end
  end
end
