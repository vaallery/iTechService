class RepairPart < ActiveRecord::Base
  belongs_to :repair_task, inverse_of: :repair_parts
  belongs_to :item
  delegate :name, :store_item, to: :item, allow_nil: true
  attr_accessible :quantity, :warranty_term, :defect_qty, :repair_task_id, :item_id
  validates_presence_of :item
  validates_numericality_of :warranty_term, only_integer: true, greater_than_or_equal_to: 0
  after_initialize { self.warranty_term ||= item.try(:warranty_term) }

  def deduct_defected
    if (store_src = Store.default).present? and (store_dst = Store.for_defect).present?
      store_item(store_src).move_to(store_dst, defect_qty)
    end
  end

end
