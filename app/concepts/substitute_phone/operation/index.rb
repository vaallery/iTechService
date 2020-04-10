class SubstitutePhone::Index < BaseOperation
  step Policy::Pundit(SubstitutePhonePolicy, :index?)
  failure :not_authorized!

  step ->(options, params:, **) {
    substitute_phones = SubstitutePhone.search(params[:query])
    options['model'] = substitute_phones
  }
end
