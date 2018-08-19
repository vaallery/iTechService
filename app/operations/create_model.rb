class CreateModel
  include ATransaction

  step :validate
  try :create, catch: ActiveRecord::RecordNotSaved

  private

  def create(attributes, model_class)
    model_class.create! attributes
  end
end
