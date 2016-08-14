class ImportedSaleDecorator < ApplicationDecorator
  delegate_all

  def sold_at
    object.sold_at.strftime('%d.%m.%y')
  end

  def presentation
    "[#{object.sold_at.strftime('%d.%m.%y')}: #{object.quantity}]"
  end
end
