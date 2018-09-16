class ItemDecorator < ApplicationDecorator
  delegate_all

  def presentation
    [name, serial_number, imei].join(' / ')
  end

  alias to_s presentation

  def status
    statuses.join(' ')
  end

  def statuses
    res = []
    res << 'in_blacklist' if stolen_phone.present?
    res << 'substitute_phone' if object.substitute_phone.present?
    res << 'trade_in' if object.trade_in_device.present?
    res << 'sold' if sale.present?
    res
  end

  def status_info
    statuses.collect do |status|
      if status == 'sold'
        I18n.t('item.status_info.sold', date: I18n.l(sale.date, format: :date))
      else
        I18n.t("item.status_info.#{status}")
      end
    end.join(' ')
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

  private

  def stolen_phone
    return @stolen_phone if defined? @stolen_phone
    @stolen_phone = object.stolen_phone.presence || StolenPhone.query(imei: object.imei, serial_number: object.serial_number).first
  end

  def sale
    return @sale if defined? @sale
    @sale = object.sales.first || imported_sale
  end

  def imported_sale
    return @imported_sale if defined? @imported_sale
    @imported_sale = ImportedSale.search(search: object.serial_number).first
  end
end
