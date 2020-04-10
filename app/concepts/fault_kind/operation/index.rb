class FaultKind::Index < BaseOperation
  step Policy::Pundit(FaultKindPolicy, :index?)
  step ->(options, params:, **) {
    options['model'] = FaultKind.ordered
  }
end