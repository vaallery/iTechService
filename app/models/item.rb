require 'barby/barcode/ean_13'
class Item < ActiveRecord::Base

  belongs_to :product, inverse_of: :items
  has_many :store_items, inverse_of: :item, dependent: :destroy
  has_many :batches, inverse_of: :item, dependent: :destroy
  has_many :sale_items, inverse_of: :item, dependent: :destroy
  has_many :movement_items, inverse_of: :item, dependent: :destroy
  has_many :features, inverse_of: :item, dependent: :destroy
  accepts_nested_attributes_for :features, allow_destroy: true
  attr_accessible :product_id, :features_attributes, :barcode_num
  validates_presence_of :product
  validates_length_of :barcode_num, is: 13, allow_nil: true
  validates_uniqueness_of :barcode_num, allow_nil: true
  validates_uniqueness_of :product_id, unless: :feature_accounting

  delegate :name, :code, :feature_accounting, :prices, :feature_types, :retail_price, :actual_prices, :quantity_in_store, :product_category, :product_group, :discount_for, :is_service, :is_equipment, :is_spare_part, :is_repair?, :request_price, :warranty_term, :quantity_threshold, :comment, to: :product, allow_nil: true

  scope :available, includes(:store_items).where('store_items.quantity > ?', 0)
  scope :in_store, lambda { |store| includes(:store_items).where(store_items: {store_id: store.is_a?(Store) ? store.id : store}) }

  paginates_per 5

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
      quantity: quantity_in_store
    }
  end

  def self.search(params)
    items = Item.scoped

    unless (q = params[:q]).blank?
      items = items.includes(:features, :product).where('features.value = :q OR products.code = :q OR items.barcode_num = :q OR LOWER(products.name) LIKE :ql', q: q, ql: "%#{q.mb_chars.downcase.to_s}%")
    end

    items
  end

  def store_item(store=nil)
    if feature_accounting
      store_items.first
    elsif store.present?
      store_items.in_store(store).first_or_create quantity: 0
    else
      nil
    end
  end

  def add_to_store(store, amount)
    if store.present? and store.is_a? Store
      if feature_accounting
        if store_items.any?
          return false
        else
          store_items.create store_id: store.id, quantity: 1
        end
      else
        store_item(store).add amount
      end
    end
  end

  def remove_from_store(store, amount=nil)
    if store.present? and store.is_a? Store
      if feature_accounting
        if store_item.present?
          store_item.destroy
        else
          return false
        end
      else
        if amount.nil?
          store_item(store).update_attribute :quantity, 0
        else
          if store_item(store).quantity < amount
            return false
          else
            store_item(store).dec amount
          end
        end
      end
    end
  end

  def actual_quantity(store=nil)
    if store.present?
      store_items.in_store(store).try(:first).try(:quantity) || 0
    else
      store_items.sum(:quantity)
    end
  end

  def generate_barcode_num
    if self.barcode_num.blank?
      num = self.id.to_s
      code = Product::BARCODE_PREFIX + '0'*(9-num.length) + num
      update_attribute :barcode_num, Barby::EAN13.new(code).to_s
    end
  end

  def purchase_price
    feature_accounting ? batches.last.try(:price) || product.purchase_price : product.purchase_price
  end

  def features_s
    features.collect(&:value).join(', ')
  end

end
