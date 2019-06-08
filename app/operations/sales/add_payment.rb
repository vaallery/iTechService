module Sales
  class AddPayment < AnOperation
    object :sale
    object :payment

    def execute
      payment.errors.add(:base, 'Продажа уже оплачена!') if sale.paid?
      payment.errors.add(:value, "Платёж не должен превышать #{sale.debt}!") if payment.value > sale.debt

      payment.sale_id = sale.id
      payment.update(sale_id: sale.id)

      errors.merge!(payment.errors) if payment.errors.any?

      payment
    end
  end
end
