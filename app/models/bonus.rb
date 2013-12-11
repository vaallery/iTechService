class Bonus < ActiveRecord::Base
  belongs_to :bonus_type, inverse_of: :bonuses
  has_one :karma_group, dependent: :nullify, inverse_of: :bonus
  attr_accessible :comment, :bonus_type_id
  validates_presence_of :bonus_type
  delegate :user, to: :karma_group
end
