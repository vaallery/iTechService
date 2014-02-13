class Product < ActiveRecord::Base

  BARCODE_PREFIX = '243'

  scope :available, includes(:store_items).where('store_items.quantity > ?', 0)
  scope :in_store, lambda { |store| includes(:store_items).where(store_items: {store_id: store.is_a?(Store) ? store.id : store}) }
  scope :goods, joins(product_group: :product_category).where(product_categories: {kind: ['equipment', 'accessory']})
  scope :services, joins(product_group: :product_category).where(product_categories: {kind: 'service'})

  belongs_to :product_group, inverse_of: :products
  belongs_to :device_type, inverse_of: :product
  has_many :items, inverse_of: :product, dependent: :destroy
  has_many :prices, class_name: 'ProductPrice', inverse_of: :product, dependent: :destroy
  has_many :store_items, through: :items, dependent: :destroy
  has_many :revaluations, inverse_of: :product, dependent: :destroy
  has_one :task, inverse_of: :product, dependent: :destroy
  has_many :product_relations, as: :parent, dependent: :destroy
  has_many :related_products, through: :product_relations, source: :relatable, source_type: 'Product'
  has_many :related_product_groups, through: :product_relations, source: :relatable, source_type: 'ProductGroup'
  has_one :top_salable, as: :salable, dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true
  accepts_nested_attributes_for :task, allow_destroy: false

  delegate :feature_accounting, :feature_types, :is_service, :is_equipment, :is_spare_part, :request_price, :product_category, to: :product_group, allow_nil: true
  delegate :full_name, to: :device_type, prefix: true, allow_nil: true
  delegate :color, to: :top_salable, allow_nil: true

  attr_accessible :code, :name, :product_group_id, :device_type_id, :warranty_term, :quantity_threshold, :comment, :items_attributes, :task_attributes, :related_product_ids, :related_product_group_ids
  validates_presence_of :name, :code, :product_group
  validates_presence_of :device_type, if: :is_equipment
  validates_uniqueness_of :code
  after_initialize do
    self.warranty_term ||= default_warranty_term
    #self.build_task if self.is_service and self.task.nil?
  end

  def self.search(params)
    products = Product.scoped

    unless (product_q = params[:product_q]).blank?
      products = products.where 'LOWER(name) LIKE :q OR code LIKE :q', q: "%#{product_q.mb_chars.downcase.to_s}%"
    end

    unless (q = params[:q]).blank?
      products = products.includes(items: :features).where('features.value = :q OR products.name LIKE :q1', q: q, q1: "%#{q}%")
    end

    products
  end

  def actual_price(price_type)
    prices.with_type(price_type).first.try(:value)
  end

  def purchase_price
    prices.purchase.first.try(:value)
  end

  def retail_price
    prices.retail.first.try(:value)
  end

  def actual_prices
    {
      purchase: purchase_price,
      retail: retail_price
    }
  end

  def quantity_in_store(store=nil)
    if store.present?
      store_items.in_store(store).sum(:quantity)
    else
      store_items.sum(:quantity)
    end
  end

  def quantity_by_stores
    Store.all.collect { |store| {id: id, code: store.code, name: store.name, quantity: quantity_in_store(store)} }
  end

  def item
    #(!feature_accounting and items.any?) ? items.first_or_create : nil
    feature_accounting ? nil : items.first_or_create
  end

  def default_warranty_term
    product_group.try(:warranty_term)
  end

  def discount_for(client)
    client.present? ? Discount::available_for(client, self) : 0
  end

  def remnants_hash
    res = {}
    Store.for_retail.each { |store| res.store store.code, quantity_in_store(store) }
    res
  end

end
