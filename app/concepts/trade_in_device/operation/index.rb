class TradeInDevice::Index < BaseOperation
  step Policy.Pundit(TradeInDevicePolicy, :index?)
  failure :not_authorized!
  step :model!

  def model!(options, params:, **)
    devices = TradeInDevice.search(params[:query], in_archive: params[:archive].present?,
                                   department_id: params[:department_id],
                                   sort_column: params[:sort_column], sort_direction: params[:sort_direction])
    options['model'] = devices
  end
end
