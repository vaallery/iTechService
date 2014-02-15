class RepairService < ActiveRecord::Base
  belongs_to :repair_group
  has_many :spare_parts
  has_many :store_items, through: :spare_parts, uniq: true
  accepts_nested_attributes_for :spare_parts
  attr_accessible :name, :price, :client_info, :repair_group_id, :spare_parts_attributes
  validates_presence_of :name, :price, :repair_group
  validates_associated :spare_parts

  def min_parts_remnants
    store_items.in_store(Store.spare_part_ids).minimum('store_items.quantity')
  end

  def total_cost
    spare_parts.sum(&:purchase_price)
  end

end
