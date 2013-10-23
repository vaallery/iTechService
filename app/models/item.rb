require 'barby/barcode/ean_13'
class Item < ActiveRecord::Base
  #include HasBarcode

  belongs_to :product, inverse_of: :items
  has_many :store_items, inverse_of: :item
  has_many :batches, inverse_of: :item
  has_many :sale_items, inverse_of: :item
  has_and_belongs_to_many :features, uniq: true
  accepts_nested_attributes_for :features, allow_destroy: true
  attr_accessible :product_id, :features_attributes
  validates_presence_of :product
  validates_length_of :barcode_num, is: 13, allow_nil: true
  validates_uniqueness_of :barcode_num, allow_nil: true
  validates_uniqueness_of :product_id, unless: :feature_accounting

  scope :available, includes(:store_items).where('store_items.quantity > ?', 0)
  scope :in_store, lambda { |store| includes(:store_items).where(store_items: {store_id: store.is_a?(Store) ? store.id : store}) }

  delegate :name, :code, :feature_accounting, :prices, :feature_types, :actual_prices, :actual_price, :available_quantity, to: :product, allow_nil: true

  paginates_per 5

  #has_barcode :barcode,
  #            type: Barby::EAN13,
  #            outputter: :svg,
  #            value: Proc.new { |i| i.barcode_num }

  after_create :generate_barcode_num

  def as_json(options={})
    {
      id: id,
      barcode_num: barcode_num,
      product_id: product_id,
      name: name,
      code: code,
      features: features,
      prices: actual_prices,
      quantity: available_quantity
    }
  end

  def self.search(params)
    items = Item.scoped

    unless (q = params[:q]).blank?
      items = items.includes(:features, :product).where('features.value = :q OR products.code = :q OR items.barcode_num = :q OR LOWER(products.name) LIKE :ql', q: q, ql: "%#{q.mb_chars.downcase.to_s}%")
    end

    items
  end

  def features_presentation
    features.any? ? features.map { |feature| "#{feature.name}: #{feature.value}" }.join('; ') : nil
  end

  def store_item(store=nil)
    if feature_accounting
      store_items.first
    elsif store.present?
      store_items.in_store(store).first
    else
      nil
    end
  end

  def generate_barcode_num
    num = self.id.to_s
    code = Product::BARCODE_PREFIX + '0'*(9-num.length) + num
    update_attribute :barcode_num, Barby::EAN13.new(code).to_s
  end

end
