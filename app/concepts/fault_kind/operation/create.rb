class FaultKind::Create < BaseOperation
  class Present < BaseOperation
    step Policy::Pundit(FaultKind::Policy, :create?)
    failure :not_authorized!
    step Model(FaultKind, :new)
    step Contract::Build(constant: FaultKind::Contract::Base)
  end

  step Nested(Present)
  step Contract::Validate(key: :fault_kind)
  failure :contract_invalid!
  step Contract::Persist()
  step ->(options, **) { options['result.message'] = I18n.t('fault_kinds.created') }
end
