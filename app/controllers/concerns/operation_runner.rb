module OperationRunner
  protected

  def run(operation, params = operation_params, &block)
    operation.(params, &block)
  end

  private

  def operation_params
    params.to_unsafe_hash.merge(current_user: current_user)
  end
end
