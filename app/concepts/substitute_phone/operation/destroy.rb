class SubstitutePhone::Destroy < BaseOperation
  step Model(SubstitutePhone, :find_by)
  failure :record_not_found!
  step Policy::Pundit(SubstitutePhonePolicy, :destroy?)
  failure :not_authorized!
  step ->(*, model:, **) { model.destroy }
  step ->(options, **) { options['result.message'] = I18n.t('substitute_phones.destroyed') }
end