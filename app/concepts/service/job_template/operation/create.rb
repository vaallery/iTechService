module Service
  class JobTemplate::Create < BaseOperation
    class Present < BaseOperation
      step Policy.Pundit(JobTemplate::Policy, :create?)
      failure :not_authorized!
      step Model(JobTemplate, :new)
      step Contract.Build(constant: JobTemplate::Contract::Base)
    end

    step Nested(Present)
    step Contract.Validate(key: :service_job_template)
    failure :contract_invalid!
    step Contract.Persist
  end
end
