module OperationRunner
  protected

  def run(operation_class, steps: nil, step_args: nil, params: action_params, &block)
    operation = operation_class.new
    operation = operation.with_step_args(step_args) unless step_args.nil?
    operation.(params, &block)
  end

  private

  def action_params
    @action_params ||= params.to_unsafe_h.symbolize_keys.except(:controller, :action)
  end
end
