class Fault::Update < BaseOperation
  class Present < BaseOperation
    step Model(Fault, :find_by)
    failure :record_not_found!
    step Policy::Pundit(Fault::Policy, :update?)
    failure :not_authorized!
    step Contract::Build(constant: Fault::Contract::Base)
  end

  step Nested(Present)
  step Contract::Validate(key: :fault)
  failure :contract_invalid!
  step Contract::Persist()
end