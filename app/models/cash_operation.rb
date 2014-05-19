class CashOperation < ActiveRecord::Base

  # default_scope includes(cash_shift: :cash_drawer).where('cash_drawers.department_id = ?', Department.current.id)
  scope :created_desc, order('created_at desc')

  belongs_to :cash_shift, inverse_of: :cash_operations
  belongs_to :user
  delegate :short_name, to: :user, prefix: true, allow_nil: true

  attr_accessible :is_out, :value, :comment
  validates_presence_of :value, :user, :cash_shift
  validates_presence_of :comment, if: :is_out
  validates_numericality_of :value, greater_than: 0
  before_validation :set_user_and_cash_shift
  after_initialize :set_user_and_cash_shift

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
      # self.find_by_uid(args[0]) if self.attribute_method?(:uid)
    end
  end

  def kind
    is_out ? 'cash_out' : 'cash_in'
  end

  private

  def set_user_and_cash_shift
    self.user_id ||= User.current.try(:id)
    self.cash_shift_id ||= User.current.try(:current_cash_shift).try(:id)
  end

end
