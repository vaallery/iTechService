class RepairTask < ActiveRecord::Base
  belongs_to :repair_service
  belongs_to :device_task
  has_many :repair_parts, inverse_of: :repair_task
  accepts_nested_attributes_for :repair_parts
  delegate :name, to: :repair_service, allow_nil: true
  attr_accessible :price, :repair_service_id, :device_task_id, :repair_parts_attributes
  validates_presence_of :price, :repair_service_id
  validates_numericality_of :price, greater_than: 0
  validates_associated :repair_parts
  validates_uniqueness_of :repair_service_id, scope: :device_task_id
  validates_associated :repair_parts

  after_initialize do
    self.price ||= repair_service.try(:price)
    if repair_service.present? and repair_parts.empty?
      repair_service.spare_parts.each { |spare_part| repair_parts.build(item_id: spare_part.product.item.id, quantity: spare_part.quantity) }
    end
  end

end
