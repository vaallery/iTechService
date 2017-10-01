class FaultKind::Destroy < BaseOperation
  step Model(FaultKind, :find_by)
  failure :record_not_found!
  step Policy::Pundit(FaultKind::Policy, :destroy?)
  failure :not_authorized!
  step ->(*, model:, **) { model.destroy }
  step ->(options, **) { options['result.message'] = I18n.t('fault_kinds.destroyed') }
end