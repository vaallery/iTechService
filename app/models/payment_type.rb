class PaymentType < ActiveRecord::Base

  attr_accessible :kind, :name
  validates_presence_of :name, :kind
  validates_inclusion_of :kind, in: [0, 1]

  KINDS = {
      0 => 'cash',
      1 => 'cashless',
  }

  def kind_s
    KINDS[kind]
  end

end
