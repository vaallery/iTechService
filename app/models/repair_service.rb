class RepairService < ActiveRecord::Base
  belongs_to :repair_group
  has_many :spare_parts, dependent: :destroy
  has_many :store_items, through: :spare_parts, uniq: true
  accepts_nested_attributes_for :spare_parts, allow_destroy: true
  attr_accessible :name, :price, :client_info, :repair_group_id, :spare_parts_attributes
  validates_presence_of :name, :price, :repair_group
  validates_associated :spare_parts

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

  def total_cost
    spare_parts.sum {|sp| sp.purchase_price || 0}
  end

  def remnants_s(store)
    %w[none low many][spare_parts.map{|sp| sp.remnant_status(store)}.min]
  end

end
