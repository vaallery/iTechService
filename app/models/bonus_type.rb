class BonusType < ActiveRecord::Base
  has_many :bonuses, dependent: :destroy, inverse_of: :bonus_type
  attr_accessible :name
  validates_presence_of :name
end
