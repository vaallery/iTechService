class RepairTask < ActiveRecord::Base
  belongs_to :repair_service
  belongs_to :device_task
  belongs_to :store
  has_many :repair_parts, inverse_of: :repair_task
  accepts_nested_attributes_for :repair_parts
  delegate :name, :repair_group, to: :repair_service, allow_nil: true
  delegate :price, to: :repair_service, prefix: true, allow_nil: true
  delegate :user, :device, :performer, :done, :done?, :pending?, :undone?, :department, to: :device_task, allow_nil: true
  attr_accessible :price, :repair_service_id, :device_task_id, :store_id, :repair_parts_attributes
  validates :price, :repair_service, :store, presence: true
  validates :price, numericality: true #, greater_than_or_equal_to: :repair_service_price
  validates :repair_service_id, uniqueness: {scope: [:device_task_id]}
  validates_associated :repair_parts

  after_initialize do
    self.price ||= repair_service.try(:price)
    self.store_id = Department.current.spare_parts_store.id
    # self.store_id = User.current.try(:spare_parts_store).try(:id)
    if repair_service.present? and repair_parts.empty?
      repair_service.spare_parts.each { |spare_part| repair_parts.build(item_id: spare_part.product.item.id, quantity: spare_part.quantity) }
    end
  end

  def margin
    price - parts_cost
  end

  def parts_cost
    repair_parts.to_a.sum(&:purchase_price)
  end

end