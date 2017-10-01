class Fault::Destroy < BaseOperation
  step Model(Fault, :find_by)
  failure :record_not_found!
  step Policy::Pundit(Fault::Policy, :destroy?)
  failure :not_authorized!
  step ->(*, model:, **) { model.destroy }
end