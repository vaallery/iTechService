class Fault::Index < BaseOperation
  step ->(options, params:, current_user:, **) {
    faults = if current_user.any_admin? || current_user.id == params[:user_id].to_i
               Fault.where(causer_id: params[:user_id])
             else
               Fault.none
             end
    options['model'] = faults.ordered.page(params[:page])
  }
end
