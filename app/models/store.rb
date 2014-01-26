class Store < ActiveRecord::Base

  scope :for_purchase, joins(:price_types).where(price_types: {kind: 0})
  scope :for_retail, joins(:price_types).where(price_types: {kind: 1})

  has_many :purchases, inverse_of: :store
  has_many :sales, inverse_of: :store
  has_many :movement_acts
  has_many :store_items, inverse_of: :store
  has_and_belongs_to_many :price_types
  attr_accessible :code, :name, :price_type_ids
  validates_presence_of :code, :name

  def self.default
    Store.find_by_code Setting.setting_value(:default_store_code)
  end

end
