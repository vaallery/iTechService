module Service
  class JobTemplate::Update < BaseOperation
    class Present < BaseOperation
      step Model(JobTemplate, :find_by)
      failure :record_not_found!
      step Policy.Pundit(JobTemplate::Policy, :update?)
      failure :not_authorized!
      step Contract.Build(constant: JobTemplate::Contract::Base)
    end

    step Nested(Present)
    step Contract.Validate(key: :service_job_template)
    failure :contract_invalid!
    step Contract.Persist
  end
end