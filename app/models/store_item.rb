class StoreItem < ActiveRecord::Base

  belongs_to :store, inverse_of: :store_items
  belongs_to :item, inverse_of: :store_items
  attr_accessible :item_id, :store_id, :quantity
  validates_presence_of :item, :store, :quantity
  validates_uniqueness_of :item_id, scope: :store_id

  scope :in_store, lambda { |store| where(store_id: store.is_a?(Store) ? store.id : store) }
  scope :available, where('quantity > ?', 0)

  def add(amount)
    update_attribute :quantity, (self.quantity || 0) + amount if amount.is_a? Integer
  end

  def dec(amount)
    update_attribute :quantity, (self.quantity || 0) - amount if amount.is_a? Integer
  end

end
