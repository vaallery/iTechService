class DutyDay < ActiveRecord::Base
  KINDS = %w[kitchen salesroom]

  attr_accessible :day, :user_id, :kind

  belongs_to :user

  validates_presence_of :day, :user_id, :kind
  validates_inclusion_of :kind, in: KINDS

  default_scope {order('day desc')}
  scope :duties_except_user, ->(user) { where('user_id <> ?', user.id) }
  scope :kitchen, ->{where(kind: 'kitchen')}
  scope :salesroom, ->{where(kind: 'salesroom')}

end
