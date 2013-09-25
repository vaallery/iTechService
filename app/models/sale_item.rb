class SaleItem < ActiveRecord::Base

  belongs_to :sale, inverse_of: :sale_items
  belongs_to :item, inverse_of: :sale_items
  attr_accessible :sale_id, :item_id, :quantity
  validates_presence_of :sale, :item, :quantity

end