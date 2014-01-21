module PaymentTypesHelper

  def payment_type_kinds_for_select
    PaymentType::KINDS.map { |pt| [t("payment_types.kinds.#{pt}"), pt] }
  end

end
