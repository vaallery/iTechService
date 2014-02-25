class ProductCategory < ActiveRecord::Base

  KINDS = %w[equipment accessory service protector spare_part]

  has_many :product_groups
  has_and_belongs_to_many :feature_types, uniq: true
  attr_accessible :name, :kind, :feature_accounting, :request_price, :warranty_term, :feature_type_ids
  validates_presence_of :name, :kind
  validates_inclusion_of :kind, in: KINDS

  before_save do |product_category|
    product_category.feature_accounting = product_category.feature_type_ids.any?
    true
  end

  def is_service
    kind == 'service'
  end

  def is_equipment
    kind == 'equipment'
  end

  def is_spare_part
    kind == 'spare_part'
  end

end
