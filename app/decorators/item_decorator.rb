class ItemDecorator < ApplicationDecorator
  delegate_all

  def presentation
    [name, serial_number, imei].join(' / ')
  end

  def features
    object.features.map { |feature| "#{feature.name}: #{feature.value}" }.join(', ')
  end

  def product
    link_to_associated :product
  end

  def serial_number
    object.serial_number || '?'
  end

  def imei
    object.imei || '?'
  end
end
