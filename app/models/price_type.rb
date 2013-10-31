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

  def kind_s
    KINDS[kind]
  end

  def self.purchase
    find_or_create_by_kind kind: 0, name: I18n.t('price_types.kinds.purchase')
  end

  def self.retail
    find_or_create_by_kind kind: 1, name: I18n.t('price_types.kinds.retail')
  end

  def is_purchase?
    kind == 0
  end

  def is_retail?
    kind == 1
  end

end
