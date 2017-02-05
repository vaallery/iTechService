class PaymentsReport < BaseReport

  def call
    result[:payment_kinds] = {}
    payments = Payment.includes(:sale).where(sales: {date: period, status: 1, is_return: false})
    result[:payments_sum] = payments.sum(:value)
    result[:payments_qty] = payments.count
    Payment::KINDS.each do |kind|
      payments_of_kind = payments.where(kind: kind)
      payments_hash = %w[card credit].include?(kind) ? payments_of_kind.group(:bank_id).sum(:value).map{|r| {bank: Bank.find(r[0]).try(:name), value: r[1]}} : payments_of_kind.map(&:attributes_hash)
      result[:payment_kinds].store kind, {payments: payments_hash, sum: payments_of_kind.sum(:value), qty: payments_of_kind.count}
    end
    result
  end
end