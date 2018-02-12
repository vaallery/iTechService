class Fault::Create < BaseOperation
  class Present < BaseOperation
    step Policy::Pundit(Fault::Policy, :create?)
    failure :not_authorized!
    step Model(Fault, :new)
    success ->(params:, model:, **) { model.causer_id = params[:user_id] }
    step Contract::Build(constant: Fault::Contract::Base)
  end

  step Nested(Present)
  step Contract::Validate(key: :fault)
  failure :contract_invalid!
  step Contract::Persist()
end
