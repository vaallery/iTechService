class SubstitutePhone::Update < BaseOperation
  class Present < BaseOperation
    step Model(SubstitutePhone, :find_by)
    failure :record_not_found!
    step Policy::Pundit(SubstitutePhonePolicy, :update?)
    failure :not_authorized!
    step Contract::Build(constant: SubstitutePhone::Contract::Base)
  end

  step Nested(Present)
  step Contract::Validate(key: :substitute_phone)
  failure :contract_invalid!
  step Contract::Persist()
  step ->(options, **) { options['result.message'] = I18n.t('substitute_phones.updated') }
end
