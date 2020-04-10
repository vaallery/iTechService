class PhoneSubstitution::Update < BaseOperation
  class Present < BaseOperation
    step Model(PhoneSubstitution, :find_by)
    failure :record_not_found!
    step Policy::Pundit(PhoneSubstitutionPolicy, :update?)
    failure :not_authorized!
    step Contract::Build(constant: PhoneSubstitution::Contract::Base)
  end

  step Nested(Present)
  step Contract::Validate(key: :phone_substitution)
  failure :contract_invalid!

  step ->(options, model:, current_user:, **) {
    PhoneSubstitution.transaction do
      model.substitute_phone.service_job_id = nil
      model.substitute_phone.save
      model.receiver = current_user
      model.withdrawn_at = Time.current
      options['contract.default'].save
    end
  }

  step ->(options, **) { options['result.message'] = I18n.t('substitute_phones.returned') }
end
