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
    step :assign_performer!
    step :assign_performed_at!
    step :persist!
    failure :get_errors!

    private

    def assign_performer!(model:, current_user:, **)
      model.performer_id = current_user.id
    end

    def assign_performed_at!(model:, **)
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
