class Store < ActiveRecord::Base
  # TODO change kind type to integer
  KINDS = %w[purchase retail spare_parts defect defect_sp]

  scope :for_purchase, joins(:price_types).where(price_types: {kind: 0})
  scope :for_retail, joins(:price_types).where(price_types: {kind: 1})
  scope :defect, where(kind: 'defect')
  scope :defect_sp, where(kind: 'defect_sp')
  scope :purchase, where(kind: 'purchase')
  scope :retail, where(kind: 'retail')
  scope :spare_parts, where(kind: 'spare_parts')

  belongs_to :department
  has_many :purchases, inverse_of: :store
  has_many :sales, inverse_of: :store
  has_many :movement_acts
  has_many :store_items, inverse_of: :store
  has_and_belongs_to_many :price_types

  delegate :name, to: :department, prefix: true, allow_nil: true

  attr_accessible :code, :name, :kind, :department_id, :price_type_ids
  validates_presence_of :name, :kind, :department

  def self.default
    Store.find_by_code Setting.setting_value(:default_store_code)
  end

  def self.spare_part_ids
    Store.spare_parts.map(&:id)
  end

end
