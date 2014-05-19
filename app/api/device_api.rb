class DeviceApi < Grape::API
  version 'v1', using: :path
  before {authenticate!}

  desc 'Show device'
  get 'devices/:id', requirements: { id: /[0-9]*/ } do
    authorize! :read, Device
    device = Device.find params[:id]
    present device
  end

  desc 'Move device to archive'
  put 'archive_devices/:id', requirements: { id: /[0-9]*/ } do
    authorize! :modify, Device
    device = Device.find params[:id]
    if device.update_attributes location_id: Location.archive.id
      present device
    else
      error!({error: device.errors.full_messages.join('. ')}, 403)
      logger.info device.errors
    end
  end

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
          error!({error: device.errors.full_messages.join('. ')}, 403)
          logger.info device.errors
        end
      else
        error!({error: I18n.t('devices.errors.invalid_action')}, 403)
      end
    else
      error!({error: I18n.t('devices.errors.no_action')}, 403)
    end
  end

  desc 'Check device status'
  get 'check_device_status/:ticket_number', requirements: {ticket_number: /[0-9]+/} do
    authorize! :read, Device
    if (device = Device.find_by_ticket_number(params[:ticket_number])).present?
      device.status_info
    else
      {status: 'not_found'}
    end
  end
end