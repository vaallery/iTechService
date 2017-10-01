class SubstitutePhone::Index < BaseOperation
  step Policy::Pundit(SubstitutePhone::Policy, :index?)

  step ->(options, params:, current_user:, **) {
    substitute_phones = SubstitutePhone.all
    if params.has_key?(:available)
      department = current_user.department
      substitute_phones = substitute_phones.available.in_department department
    end
    substitute_phones.search(params[:query])
    options['model'] = substitute_phones
  }
end