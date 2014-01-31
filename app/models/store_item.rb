class StoreItem < ActiveRecord::Base

  scope :in_store, lambda { |store| where(store_id: store.is_a?(Store) ? store.id : store) }
  scope :available, where('quantity > ?', 0)
  scope :for_product, lambda { |product| includes(:item).where(items: {product_id: (product.is_a?(Product) ? product.id : product)}) }

  belongs_to :item, inverse_of: :store_items
  belongs_to :store, inverse_of: :store_items

  delegate :feature_accounting, :features, :name, to: :item, allow_nil: true
  delegate :name, :code, to: :store, prefix: true, allow_nil: true

  attr_accessible :item_id, :store_id, :quantity
  validates_presence_of :item, :store, :quantity
  validates_uniqueness_of :item_id, scope: :store_id
  validates_numericality_of :quantity, only_integer: true
  validates_numericality_of :quantity, only_integer: true, equal_to: 1, if: :feature_accounting

  def add(amount)
    unless feature_accounting
      amount = amount.to_i
      update_attribute :quantity, (self.quantity || 0) + amount if amount.is_a? Integer
    end
  end

  def dec(amount)
    unless feature_accounting
      amount = amount.to_i
      update_attribute :quantity, (self.quantity || 0) - amount if amount.is_a? Integer
    end
  end

  def move_to(dst_store, amount=0)
    if feature_accounting
      update_attribute :store_id, dst_store.id
    else
      dec amount
      if (store_item = StoreItem.find_by_item_id_and_store_id(item_id, dst_store.id)).present?
        store_item.add amount
      else
        StoreItem.create store_id: dst_store.id, item_id: item_id, quantity: amount
      end
    end
  end

end
