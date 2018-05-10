module Service
  class FreeJob::Update < BaseOperation
    class Present < BaseOperation
      step Model(FreeJob, :find_by)
      failure :record_not_found!
      step Policy.Pundit(FreeJob::Policy, :update?)
      failure :not_authorized!
      step Contract.Build(constant: FreeJob::Contract::Base)
    end

    step Nested(Present)
    step Contract.Validate(key: :service_free_job)
    failure :contract_invalid!
    step Contract.Persist
  end
end