module PaymentTypesHelper

  def payment_type_kinds_for_select
    PaymentType::KINDS.to_a.map { |pt| [t("payment_types.kinds.#{pt[1]}"), pt[0]] }
  end

end
