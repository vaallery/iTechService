class ItemDecorator < ApplicationDecorator
  delegate_all

  def presentation
    [name, serial_number].compact.join(' / ')
  end

  def features
    object.features.map { |feature| "#{feature.name}: #{feature.value}" }.join(', ')
  end

  def product
    link_to_associated :product
  end

end
