class PriceType < ActiveRecord::Base

  KINDS = {
    0 => 'purchase',
    1 => 'retail',
    2 => 'other'
  }

  has_many :product_prices, inverse_of: :price_type, primary_key: :uid
  has_many :revaluation_acts, inverse_of: :price_type
  has_and_belongs_to_many :stores, finder_sql: proc { "SELECT stores.* FROM stores INNER JOIN price_types_stores ON stores.uid = price_types_stores.store_id WHERE price_types_stores.price_type_id = '#{uid}'"}
  attr_accessible :name, :kind
  validates_presence_of :name, :kind
  validates_inclusion_of :kind, in: KINDS.keys
  validates_uniqueness_of :kind
  after_create UidCallbacks

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

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
