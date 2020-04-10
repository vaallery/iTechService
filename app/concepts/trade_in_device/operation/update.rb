class TradeInDevice::Update < BaseOperation
  class Present < BaseOperation
    step Model(TradeInDevice, :find_by)
    failure :record_not_found!
    step Policy.Pundit(TradeInDevicePolicy, :update?)
    failure :not_authorized!
    step Contract.Build(constant: TradeInDevice::Contract)
  end

  step Nested(Present)
  step Contract.Validate(key: :trade_in_device)
  failure :contract_invalid!
  step Contract.Persist
  step ->(options, **) { options['result.message'] = I18n.t('trade_in_device.updated') }
end
