module Service
  class FreeJob::Create < BaseOperation
    class Present < BaseOperation
      step Policy.Pundit(FreeJob::Policy, :create?)
      failure :not_authorized!
      step Model(FreeJob, :new)
      step Contract.Build(constant: FreeJob::Contract::Base)
    end

    step Nested(Present)
    step Contract.Validate(key: :service_free_job)
    failure :contract_invalid!
    step Contract.Persist(method: :sync)
    step :prepare!
    step :persist!
    failure :get_errors!

    private

    def prepare!(model:, current_user:, **)
      model.receiver_id = current_user.id
      model.performer_id ||= current_user.id
      model.performed_at = Time.current
    end

    def persist!(model:, **)
      model.save
    end

    def get_errors!(options, model:, **)
      options['result.message'] = model.errors.full_messages.join('. ')
    end
  end
end
