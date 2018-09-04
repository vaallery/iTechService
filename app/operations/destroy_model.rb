class DestroyModel < ATransaction
  try :destroy, catch: [ActiveRecord::RecordNotFound, ActiveRecord::RecordNotDestroyed]

  private

  def destroy(params, model_class)
    model = model_class.find params[:id]
    model.destroy!
  end
end
