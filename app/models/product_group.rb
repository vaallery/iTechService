class ProductGroup < ActiveRecord::Base

  scope :ordered, order('id asc')
  scope :name_asc, order('name asc')
  scope :services, joins(:product_category).where(product_categories: {kind: 'service'})
  scope :goods, joins(:product_category).where(product_categories: {kind: %w[equipment accessory]})
  scope :except_spare_parts, joins(:product_category).where(product_categories: {kind: %w[equipment accessory protector service]})
  scope :except_spare_parts_and_services, joins(:product_category).where(product_categories: {kind: %w[equipment accessory protector]})
  scope :spare_parts, joins(:product_category).where(product_categories: {kind: 'spare_part'})
  scope :for_purchase, joins(:product_category).where(product_categories: {kind: %w[equipment accessory protector spare_part]})

  belongs_to :product_category
  has_many :products, inverse_of: :product_group
  has_many :product_relations, as: :parent, dependent: :destroy
  has_many :related_products, through: :product_relations, source: :relatable, source_type: 'Product'
  has_many :related_product_groups, through: :product_relations, source: :relatable, source_type: 'ProductGroup'
  has_ancestry orphan_strategy: :restrict, cache_depth: true

  delegate :feature_accounting, :feature_types, :warranty_term, :is_service, :is_equipment, :is_spare_part, :request_price, to: :product_category, allow_nil: true

  attr_accessible :code, :name, :ancestry, :parent_id, :product_category_id, :related_product_ids, :related_product_group_ids
  validates_presence_of :name, :product_category

  after_initialize do |product_group|
    product_group.parent_id = nil if product_group.parent_id.blank?
    unless product_group.is_root?
      product_group.product_category_id ||= product_group.parent.product_category_id
    end
  end

  def self.search(params)
    product_groups = ProductGroup.scoped

    if (form = params[:form]).present?
      case form
        when 'repair_service' then product_groups = product_groups.spare_parts
        when 'purchase' then product_groups = product_groups.for_purchase
        when 'sale' then product_groups = product_groups.except_spare_parts_and_services
        when 'movement_act' then product_groups = User.current.technician? ? product_groups.spare_parts : product_groups.except_spare_parts
        else product_groups
      end
    end

    if (store_kind = params[:store_kind]).present?
      case store_kind
        when 'spare_parts', 'defect_sp' then product_groups = product_groups.spare_parts
        else product_groups = product_groups.except_spare_parts_and_services
      end
    end

    product_groups
  end

end
