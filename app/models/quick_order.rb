class QuickOrder < ActiveRecord::Base

  scope :id_asc, order('id asc')
  scope :created_desc, order('created_at desc')
  scope :month_ago, where(created_at: 1.month.ago)

  belongs_to :user
  attr_accessible :client_name, :comment, :contact_phone, :number
  after_initialize { self.user_id ||= User.current.try(:id) }
  before_create :set_number

  private

  def set_number
    last_number = QuickOrder.created_desc.first.try(:number)
    self.number = (last_number.present? and last_number < 9999) ? last_number.next : 1
  end

end
