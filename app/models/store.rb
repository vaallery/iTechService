class Store < ActiveRecord::Base

  KINDS = %w[purchase retail spare_parts defect]

  scope :for_purchase, joins(:price_types).where(price_types: {kind: 0})
  scope :for_retail, joins(:price_types).where(price_types: {kind: 1})
  scope :defect, where(kind: 'defect')
  scope :purchase, where(kind: 'purchase')
  scope :retail, where(kind: 'retail')
  scope :spare_parts, where(kind: 'spare_parts')

  has_many :purchases, inverse_of: :store
  has_many :sales, inverse_of: :store
  has_many :movement_acts
  has_many :store_items, inverse_of: :store
  has_and_belongs_to_many :price_types
  attr_accessible :code, :name, :kind, :price_type_ids
  validates_presence_of :code, :name

  def self.default
    Store.find_by_code Setting.setting_value(:default_store_code)
  end

  def self.spare_parts_default
    Store.spare_parts.first
  end

end
