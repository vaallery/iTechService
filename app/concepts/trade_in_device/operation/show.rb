class TradeInDevice::Show < BaseOperation
  step Policy.Pundit(TradeInDevicePolicy, :show?)
  failure :not_authorized!
  step Model(TradeInDevice, :find_by)
  failure :record_not_found!
end
