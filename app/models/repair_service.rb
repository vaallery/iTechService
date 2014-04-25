class RepairService < ActiveRecord::Base
  belongs_to :repair_group
  has_many :spare_parts, dependent: :destroy
  has_many :store_items, through: :spare_parts, uniq: true
  accepts_nested_attributes_for :spare_parts, allow_destroy: true
  attr_accessible :name, :price, :client_info, :repair_group_id, :spare_parts_attributes
  validates_presence_of :name, :price, :repair_group
  validates_associated :spare_parts

  def total_cost
    spare_parts.sum {|sp| sp.purchase_price || 0}
  end

  def remnants_s(store)
    value = spare_parts.min {|sp| sp.remnant_s(store)}.quantity
    if value.nil?
      '-'
    elsif value <= 0
      'none'
    elsif value > (quantity_threshold || 0)
      'many'
    else
      'low'
    end
    # '-'
  end

end
