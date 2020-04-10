module Service
  class FreeTask::Update < BaseOperation
    class Present < BaseOperation
      step Model(FreeTask, :find_by)
      failure :record_not_found!
      step Policy.Pundit(FreeTaskPolicy, :update?)
      failure :not_authorized!
      step Contract.Build(constant: FreeTask::Contract::Base)
    end

    step Nested(Present)
    step Contract.Validate(key: :service_free_task)
    failure :contract_invalid!
    step Contract.Persist
  end
end