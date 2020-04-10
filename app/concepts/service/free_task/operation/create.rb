module Service
  class FreeTask::Create < BaseOperation
    class Present < BaseOperation
      step Policy.Pundit(FreeTaskPolicy, :create?)
      failure :not_authorized!
      step Model(FreeTask, :new)
      step Contract.Build(constant: FreeTask::Contract::Base)
    end

    step Nested(Present)
    step Contract.Validate(key: :service_free_task)
    failure :contract_invalid!
    step Contract.Persist
  end
end
