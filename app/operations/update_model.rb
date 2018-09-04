class UpdateModel
  include ATransaction

  step :validate
  try :update, catch: [ActiveRecord::RecordNotFound, ActiveRecord::RecordNotSaved]

  private

  def update(attributes, model_class, id)
    model = model_class.find(id)
    model.update! attributes
    model
  end
end
