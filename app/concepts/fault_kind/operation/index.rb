class FaultKind::Index < BaseOperation
  step Policy::Pundit(FaultKind::Policy, :index?)
  step ->(options, params:, **) {
    options['model'] = FaultKind.ordered
  }
end