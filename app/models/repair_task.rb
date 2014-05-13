class RepairTask < ActiveRecord::Base

  belongs_to :repair_service, primary_key: :uid
  belongs_to :device_task, primary_key: :uid
  belongs_to :store, primary_key: :uid
  has_many :repair_parts, inverse_of: :repair_task, primary_key: :uid

  accepts_nested_attributes_for :repair_parts

  delegate :name, :repair_group, to: :repair_service, allow_nil: true
  delegate :price, to: :repair_service, prefix: true, allow_nil: true
  delegate :user, :device, :performer, to: :device_task, allow_nil: true

  attr_accessible :price, :repair_service_id, :device_task_id, :store_id, :repair_parts_attributes
  validates_presence_of :price, :repair_service, :store
  validates_numericality_of :price#, greater_than_or_equal_to: :repair_service_price
  validates_associated :repair_parts
  validates_uniqueness_of :repair_service_id, scope: :device_task_id
  validates_associated :repair_parts
  after_create UidCallbacks

  after_initialize do
    self.price ||= repair_service.try(:price)
    self.store_id = User.current.try(:spare_parts_store).try(:uid)
    if repair_service.present? and repair_parts.empty?
      repair_service.spare_parts.each { |spare_part| repair_parts.build(item_id: spare_part.product.item.uid, quantity: spare_part.quantity) }
    end
  end

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

  def margin
    price - parts_cost
  end

  def parts_cost
    repair_parts.to_a.sum(&:purchase_price)
  end

end