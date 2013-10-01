module PriceTypesHelper

  def price_type_kinds_for_select
    PriceType::KINDS.to_a.map {|pt| [t("price_types.kinds.#{pt[1]}"), pt[0]]}
  end

end
