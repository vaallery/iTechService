class ServiceJobDecorator < ApplicationDecorator
  delegate_all

  def device

  end

  def device_name
    (object.item.present? ? object.item.name : object.type_name) || '-'
  end

  def serial_number
    (object.item.present? ? object.item.serial_number : object.serial_number) || '-'
  end

  def imei
    (object.item.present? ? object.item.imei : object.imei) || '-'
  end

  def data_storages
    object.data_storages.map do |storage_num|
      h.content_tag(:span, storage_num, class: 'data_storage_label')
    end.join(' ').html_safe
  end
end
