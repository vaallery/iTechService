class Item < ActiveRecord::Base

  belongs_to :product, inverse_of: :items
  has_many :store_items, inverse_of: :item
  has_many :batches, inverse_of: :item
  has_many :sale_items, inverse_of: :item
  has_and_belongs_to_many :features, uniq: true
  accepts_nested_attributes_for :features, allow_destroy: true
  attr_accessible :product_id, :features_attributes
  validates_presence_of :product

  scope :available, includes(:store_items).where('store_items.quantity > ?', 0)
  scope :in_store, lambda { |store| includes(:store_items).where(store_items: {store_id: store.is_a?(Store) ? store.id : store}) }

  delegate :name, :code, :feature_accounting, :prices, :feature_types, :actual_prices, :actual_price, :available_quantity, to: :product, allow_nil: true

  paginates_per 5

  def self.search(params)
    items = Item.scoped
    unless (item_q = params[:item_q]).blank?
      items = includes(:features).where('features.value LIKE :q', q: "%#{item_q}%")
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
