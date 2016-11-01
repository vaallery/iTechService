class Fault < ApplicationRecord
  belongs_to :causer, class_name: 'User'
  belongs_to :kind, class_name: 'FaultKind'

  scope :ordered, -> { order date: :desc }
  # scope :expireable, -> { includes(:kind).where(fault_kinds: {is_permanent: false}).references(:fault_kinds) }
  scope :expireable, -> { where(kind: FaultKind.expireable) }

  delegate :name, :icon, :icon_url, to: :kind, allow_nil: true

  def self.employee_faults_count_by_kind_on(employee, date)
    total_counts = employee.faults.where('faults.date <= ?', date).group(:kind_id).count
    start_date = employee.salary_date_at(date.prev_month).tomorrow
    month_counts = employee.faults.where(date: start_date..date).group(:kind_id).count

    result = {}
    total_counts.each do |id, count|
      month_count = month_counts.fetch id, 0
      fault_kind = FaultKind.find id
      result.store fault_kind, {month: month_count, total: count}
    end
    return result
  end
end