class Fault::Index < BaseOperation
  step Policy::Pundit(Fault::Policy, :index?)
  step ->(options, params:, **) {
    options['model'] = Fault.where(causer_id: params[:user_id]).ordered.page(params[:page])
  }
end