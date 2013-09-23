class StoreItem < ActiveRecord::Base

  belongs_to :store, inverse_of: :store_items
  belongs_to :item, inverse_of: :store_items
  attr_accessible :item_id, :store_id, :quantity
  validates_presence_of :item, :store, :quantity

end
