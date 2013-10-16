require 'barby/barcode/ean_13'
class Item < ActiveRecord::Base
  include HasBarcode

  belongs_to :product, inverse_of: :items
  has_many :store_items, inverse_of: :item
  has_many :batches, inverse_of: :item
  has_many :sale_items, inverse_of: :item
  has_and_belongs_to_many :features, uniq: true
  accepts_nested_attributes_for :features, allow_destroy: true
  attr_accessible :product_id, :features_attributes
  validates_presence_of :product
  validates_length_of :barcode_num, is: 12, allow_nil: true
  validates_uniqueness_of :product_id, unless: :feature_accounting

  scope :available, includes(:store_items).where('store_items.quantity > ?', 0)
  scope :in_store, lambda { |store| includes(:store_items).where(store_items: {store_id: store.is_a?(Store) ? store.id : store}) }

  delegate :name, :code, :feature_accounting, :prices, :feature_types, :actual_prices, :actual_price, :available_quantity, to: :product, allow_nil: true

  paginates_per 5

  has_barcode :barcode,
              type: Barby::EAN13,
              outputter: :svg,
              value: Proc.new { |i| i.barcode_num.to_s }

  def self.search(params)
    items = Item.scoped

    unless (q = params[:q]).blank?
      items = items.includes(:features, :product).where('features.value = :q OR products.code = :q OR items.barcode_num = :qi OR LOWER(products.name) LIKE :ql', q: q, ql: "%#{q.mb_chars.downcase.to_s}%", qi: q.to_i)
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

end
