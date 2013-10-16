class PriceType < ActiveRecord::Base

  has_many :product_prices, inverse_of: :price_type
  has_many :revaluation_acts, inverse_of: :price_type
  has_and_belongs_to_many :stores
  attr_accessible :name, :kind
  validates_presence_of :name, :kind
  validates_inclusion_of :kind, in: 0..2

  scope :purchase, where(kind: 0)
  scope :retail, where(kind: 1)

  KINDS = {
    0 => 'purchase',
    1 => 'retail',
    2 => 'other'
  }

  def kind_s
    KINDS[kind]
  end

end
