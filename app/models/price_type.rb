class PriceType < ActiveRecord::Base

  KINDS = {
    0 => 'purchase',
    1 => 'retail',
    2 => 'other'
  }

  has_many :product_prices, inverse_of: :price_type
  has_many :revaluation_acts, inverse_of: :price_type
  has_and_belongs_to_many :stores
  attr_accessible :name, :kind
  validates_presence_of :name, :kind
  validates_inclusion_of :kind, in: 0..2
  validates_uniqueness_of :kind

  scope :purchase, where(kind: 0)
  scope :retail, where(kind: 1)

  def kind_s
    KINDS[kind]
  end

end
