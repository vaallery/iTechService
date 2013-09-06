class StoreItem < ActiveRecord::Base
  belongs_to :store
  belongs_to :item
  attr_accessible :item_id, :store_id, :quantity
  validates_presence_of :item, :store
end
