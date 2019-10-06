class RepairPart < ActiveRecord::Base
  attr_accessor :is_warranty, :contractor_id

  belongs_to :repair_task, inverse_of: :repair_parts
  belongs_to :item
  has_many :spare_part_defects, inverse_of: :repair_part

  delegate :name, :store_item, :code, :purchase_price, :product, to: :item, allow_nil: true
  delegate :store, to: :repair_task, allow_nil: true

  accepts_nested_attributes_for :spare_part_defects
  attr_accessible :quantity, :warranty_term, :repair_task_id, :item_id, :spare_part_defects_attributes, :is_warranty, :contractor_id
  validates_presence_of :item
  validates_numericality_of :warranty_term, only_integer: true, greater_than_or_equal_to: 0

  after_initialize do
    self.warranty_term ||= item.try(:warranty_term)
  end

  def defect_qty
    return self['defect_qty'] if self['defect_qty'].present?

    spare_part_defects.sum(:qty)
  end

  def deduct_spare_parts
    result = false
    if (store_src = Department.current.repair_store).present?
      result = self.store_item(store_src).dec(self.quantity)
    end
    !!result
  end

  def stash
    result = false
    if (store_src = self.store).present? and (store_dst = Department.current.repair_store).present?
      result = self.store_item(store_src).move_to(store_dst, self.quantity)
    end
    !!result
  end

  def unstash
    result = false
    if (store_src = Department.current.repair_store).present? and (store_dst = self.store).present?
      result = self.store_item(store_src).move_to(store_dst, self.quantity)
    end
    !!result
  end

  def last_batch_price
    item.batches.last_posted&.price
  end
end
