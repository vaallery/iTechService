class QuickOrderApi < Grape::API
  version 'v1', using: :path
  before { authenticate! }

  desc 'Quick Tasks list'
  get 'quick_tasks' do
    QuickTask.all.as_json(only: [:id, :name])
  end

  desc 'Create Quick Order'
  params do
    requires :quick_order
  end
  post 'quick_orders' do
    authorize! :create, QuickOrder
    quick_order = QuickOrder.new(params[:quick_order])
    if quick_order.save
      present quick_order
    else
      error!({error: quick_order.errors}, 422)
    end
  end

end