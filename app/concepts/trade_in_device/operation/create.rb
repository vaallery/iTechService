class TradeInDevice::Create < BaseOperation
  class Present < BaseOperation
    step Policy.Pundit(TradeInDevice::Policy, :create?)
    failure :not_authorized!
    step Model(TradeInDevice, :new)
    step Contract.Build(constant: TradeInDevice::Contract)
  end

  step Nested(Present)
  step Contract.Validate(key: :trade_in_device)
  failure :contract_invalid!
  step Contract.Persist(method: :sync)
  step :assign_received_at
  step :assign_number
  step :assign_receiver
  step :save_model
  step :success_message

  def assign_received_at(model:, **)
    model.received_at = Time.current
  end

  def assign_number(model:, **)
    number = TradeInDevice.maximum(:number) || 0
    model.number = number.next
  end

  def assign_receiver(model:, current_user:, **)
    model.receiver = current_user
  end

  def save_model(model:, **)
    model.save
  end

  def success_message(options, **)
    options['result.message'] = I18n.t('trade_in_device.created')
  end
end
