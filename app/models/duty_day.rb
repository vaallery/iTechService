class DutyDay < ActiveRecord::Base
  belongs_to :user
  attr_accessible :day, :user_id

  default_scope order('day desc')
  scope :duties_except_user, lambda { |user| where('user_id <> ?', user.id) }

  validates :day, :user_id, presence: true

end
