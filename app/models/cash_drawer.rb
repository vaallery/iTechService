class CashDrawer < ActiveRecord::Base

  belongs_to :department, primary_key: :uid
  has_many :cash_shifts, inverse_of: :cash_drawer, primary_key: :uid
  delegate :name, to: :department, prefix: true, allow_nil: true
  attr_accessible :name, :department_id
  validates_presence_of :name, :department
  after_create UidCallbacks

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
      # self.find_by_uid(args[0]) if self.attribute_method?(:uid)
    end
  end


  def current_shift
    cash_shifts.opened.first_or_create(is_closed: false)
  end

end
