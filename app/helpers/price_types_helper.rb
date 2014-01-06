module PriceTypesHelper

  def price_type_kinds_for_select
    PriceType::KINDS.to_a.map {|pt| [t("price_types.kinds.#{pt[1]}"), pt[0]]}
  end

  def price_types_presentation(price_types)
    if price_types.present?
      price_types.collect { |pt| pt.name }.join(', ')
    end
  end

end
