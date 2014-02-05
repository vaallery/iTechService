class CashShift < ActiveRecord::Base

  scope :closed, where(is_closed: true)

  belongs_to :user
  has_many :sales, inverse_of: :cash_shift
  delegate :short_name, to: :user, prefix: true, allow_nil: true
  attr_accessible :is_closed

  def self.current
    find_or_create_by_is_closed false
  end

  def close
    if is_closed
      errors[:base] << t('cash_shifts.errors.already_closed')
    else
      sales.unposted.destroy_all
      update_attribute :is_closed, true
      update_attribute :closed_at, DateTime.current
      update_attribute :user_id, User.current
    end
  end

  def sales_total(is_return=false)
    sales.posted.where(is_return: is_return).sum &:payments_sum
  end

  def sales_total_by_kind(is_return=false)
    res = []
    sale_ids = sales.posted.where(is_return: is_return).map(&:id)
    Payment::KINDS.each do |kind|
      value = Payment.where(kind: kind, sale_id: sale_ids).sum(:value)
      res << [kind, value]
    end
    res
  end

  def sales_count(is_return=false)
    sales.posted.where(is_return: is_return).count
  end

  def pays_total(is_out=false)

  end

  def encashments_by_kind
    res = []
    sale_ids = sales.posted.selling.map(&:id)
    return_ids = sales.posted.returning.map(&:id)
    Payment::KINDS.each do |kind|
      value = Payment.where(kind: kind, sale_id: sale_ids).sum(:value) - Payment.where(kind: kind, sale_id: return_ids).sum(:value)
      res << [kind, value]
    end
    res
  end

  def encashment_total
    sales_total - sales_total(true)
  end

end
