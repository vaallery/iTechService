class Store < ActiveRecord::Base

  has_many :purchases, inverse_of: :store
  has_many :sales, inverse_of: :store
  has_many :store_items, inverse_of: :store
  has_and_belongs_to_many :price_types
  attr_accessible :code, :name, :price_type_ids
  validates_presence_of :code, :name

  scope :for_purchase, joins(:price_types).where(price_types: {kind: 0})
  scope :for_retail, joins(:price_types).where(price_types: {kind: 1})

end
