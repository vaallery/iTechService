class PaymentType < ActiveRecord::Base

  attr_accessible :kind, :name
  validates_presence_of :name, :kind
  validates_inclusion_of :kind, in: [0, 1]

  scope :cash, where(kind: 0)
  scope :sachless, where(kind: 1)

  KINDS = {
      0 => 'cash',
      1 => 'cashless',
      2 => 'mixed',
      3 => 'credit',
      4 => 'gift_card'
  }

  def kind_s
    KINDS[kind]
  end

end
