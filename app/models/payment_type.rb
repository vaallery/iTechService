class PaymentType < ActiveRecord::Base

  KINDS = %w[cash cashless mixed credit gift_card]

  scope :cash, ->{where(kind: 'cash')}
  scope :sachless, ->{where(kind: 'cashless')}

  attr_accessible :kind, :name
  validates_presence_of :name, :kind
  validates_inclusion_of :kind, in: KINDS

end
