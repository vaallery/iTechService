class ApplicationDecorator < Draper::Decorator
  delegate :current_page, :total_pages, :limit_value
  delegate :link_to, to: :helpers

  def created_at
    human_datetime object.created_at
  end

  def updated_at
    human_datetime object.updated_at
  end

  def time
    human_datetime object.updated_at
  end

  def timestamp
    "[#{I18n.t('attributes.created_at')}: #{created_at} | " +
      "#{I18n.t('attributes.updated_at')}: #{updated_at}]"
  end

  def department
    object.department.name
  end

  def price
    object.price.present? ? ActiveSupport::NumberHelper.number_to_currency(object.price, precision: 0, unit: '') : '-'
  end

  def cost
    object.cost.present? ? ActiveSupport::NumberHelper.number_to_currency(object.cost, precision: 2, unit: '') : '-'
  end

  def user
    if object.user.present?
      h.link_to object.user.decorate.presentation, object.user
    end
  end

  private

  def human_integer(value)
    ActiveSupport::NumberHelper.number_to_currency(value, precision: 0, unit: '')
  end

  def human_decimal(value)
    ActiveSupport::NumberHelper.number_to_delimited(value.round(2), locale: :ru)
  end

  def human_date(value)
    value.strftime '%d.%m.%Y'
  end

  def human_datetime(value)
    value.strftime '%d.%m.%Y %H:%M'
  end

  def human_phone_number(number)
    h.number_to_phone(number, area_code: true)
  end

  def currency(number)
    ActiveSupport::NumberHelper.number_to_currency(number, precision: 0)#, unit: '')
  end

  def link_to_associated(association_name)
    if object.respond_to?(association_name) && (associated = object.send(association_name)).present?
      h.link_to associated.respond_to?(:presentation) ? associated.presentation : associated.name, associated, target: '_blank'
    end
  end

end
