module PaymentsHelper

  def human_payment_kind(payment)
    t "payments.kinds.#{payment.kind}"
  end

  def payment_kinds_for_select
    Payment::KINDS.map { |k| [t("payments.kinds.#{k}"), k] }
  end

end
