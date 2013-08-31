class StockItem < ActiveRecord::Base
  belongs_to :store
  belongs_to :item, polymorphic: true
  attr_accessible :item, :quantity, :item_id, :item_type
end
