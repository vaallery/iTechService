class SubstitutePhone::Stock::Index < BaseOperation
  step Policy::Pundit(SubstitutePhonePolicy, :view_stock?)
  failure :not_authorized!

  step ->(options, params:, current_user:, **) {
    department = current_user.department
    substitute_phones = SubstitutePhone.available.in_department(department).search(params[:search])
    options['model'] = substitute_phones
  }
end
