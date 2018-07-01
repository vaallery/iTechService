class PaymentsReport < BaseReport

  def call
    result[:payment_kinds] = {}
    payments = Payment.includes(:sale).where(sales: {date: period, status: 1})

    Payment::KINDS.each do |kind|
      payments_of_kind = payments.where(kind: kind)
      payments_hash = if %w[card credit].include?(kind)
                        bank_payments_hash payments_of_kind
                      else
                        payments_of_kind.map(&:attributes_hash)
                      end

      sales_sum = payments_of_kind.sales.sum(:value)
      returns_sum = payments_of_kind.returns.sum(:value)
      result_sum = sales_sum - returns_sum

      result[:payment_kinds].store kind, {
        payments: payments_hash,
        sales_sum: sales_sum,
        returns_sum: returns_sum,
        result_sum: result_sum,
        qty: payments_of_kind.count
      }
    end

    result[:sales_sum] = payments.sales.sum(:value)
    result[:returns_sum] = payments.returns.sum(:value)
    result[:result_sum] = result[:sales_sum] - result[:returns_sum]
    result[:payments_qty] = payments.count
    result
  end

  private

  def bank_payments_hash(payments)
    payments.group(:bank_id).sum(:value).map do |r|
      {bank: Bank.find_by(id: r[0]).try(:name), value: r[1]}
    end
  end
end