class SubstitutePhone::Show < BaseOperation
  step Model(SubstitutePhone, :find_by)
  failure :record_not_found!
  step Policy::Pundit(SubstitutePhonePolicy, :show?)
  failure :not_authorized!
end