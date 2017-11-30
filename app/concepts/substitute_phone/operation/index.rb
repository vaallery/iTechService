class SubstitutePhone::Index < BaseOperation
  step Policy::Pundit(SubstitutePhone::Policy, :index?)
  failure :not_authorized!

  step ->(options, params:, **) {
    substitute_phones = SubstitutePhone.search(params[:query])
    options['model'] = substitute_phones
  }
end
