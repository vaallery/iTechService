class Store < ActiveRecord::Base
  # TODO change kind type to integer
  KINDS = %w[purchase retail spare_parts defect defect_sp]

  default_scope order('stores.name asc')
  scope :ordered, order('id asc')
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
  has_many :items, through: :store_items
  has_many :products, through: :items
  has_many :store_products, dependent: :destroy
  has_and_belongs_to_many :price_types, finder_sql: proc { "SELECT price_types.* FROM price_types INNER JOIN price_types_stores ON price_types.uid = price_types_stores.price_type_id WHERE price_types_stores.store_id = '#{uid}'"}

  delegate :name, to: :department, prefix: true, allow_nil: true

  attr_accessible :code, :name, :kind, :department_id, :price_type_ids
  validates_presence_of :name, :kind, :department

  def self.search(params)
    stores = self.scoped

    unless (kind = params[:kind]).blank?
      stores = stores.where kind: kind
    end

    stores
  end

  def self.spare_part_ids
    Store.spare_parts.map(&:id)
  end

  def is_spare_parts?
    kind == 'spare_parts'
  end

  def is_defect?
    kind.in? %w[defect defect_sp]
  end

end
