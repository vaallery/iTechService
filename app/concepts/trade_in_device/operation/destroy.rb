class TradeInDevice::Destroy < BaseOperation
  step Model(TradeInDevice, :find_by)
  failure :record_not_found!
  step Policy.Pundit(TradeInDevicePolicy, :destroy?)
  failure :not_authorized!
  step ->(model:, **) { model.destroy }
  failure ->(options, **) { options['result.message'] = I18n.t('trade_in_device.not_destroyed') }
  step ->(options, **) { options['result.message'] = I18n.t('trade_in_device.destroyed') }
end
