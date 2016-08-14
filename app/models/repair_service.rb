class RepairService < ActiveRecord::Base
  default_scope {order('name asc')}
  belongs_to :repair_group
  has_many :spare_parts, dependent: :destroy
  has_many :store_items, through: :spare_parts
  accepts_nested_attributes_for :spare_parts, allow_destroy: true
  attr_accessible :name, :price, :client_info, :repair_group_id, :spare_parts_attributes, :is_positive_price
  validates_presence_of :name, :price, :repair_group
  validates_associated :spare_parts

  def total_cost
    spare_parts.to_a.sum {|sp| sp.purchase_price || 0}
  end

  def remnants_s(store)
    %w[none low many][spare_parts.map{|sp| sp.remnant_status(store)}.min] if spare_parts.present?
  end

  def self.update_prices(params)
    params.each do |key, value|
      repair_service = RepairService.find(key)
      repair_service.update_attributes price: value
    end
  end

end
