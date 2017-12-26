class TradeInDevice::Index < BaseOperation
  step Policy.Pundit(TradeInDevice::Policy, :index?)
  failure :not_authorized!
  step :model!

  def model!(options, params:, **)
    devices = TradeInDevice.search(params[:query], in_archive: params.key?(:archive))
    options['model'] = devices
  end
end
