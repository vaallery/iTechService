class DeviceApi < Grape::API
  version 'v1', using: :path
  before { authenticate! }

  desc 'Move device'
  params do
    requires :move
  end
  put 'devices/:id', requirements: { id: /[0-9]*/ } do
    authorize! :modify, Device
    if (location = params[:move]).present?
      if Location.respond_to? location+'_id'
        device = Device.find params[:id]
        if device.update_attributes location_id: Location.send(location+'_id')
          present device
        else
          error!({error: device.errors.full_messages}, 403)
          logger.info device.errors
        end
      else
        error!({error: I18n.t('devices.errors.invalid_action')}, 403)
      end
    else
      error!({error: I18n.t('devices.errors.no_action')}, 403)
    end
  end
end