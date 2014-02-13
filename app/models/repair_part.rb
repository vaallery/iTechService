class RepairPart < ActiveRecord::Base
  belongs_to :repair_task, inverse_of: :repair_parts
  belongs_to :item
  delegate :name, :store_item, to: :item, allow_nil: true
  attr_accessible :quantity, :warranty_term, :defect_qty, :repair_task_id, :item_id
  validates_presence_of :item
  validates_numericality_of :warranty_term, only_integer: true, greater_than_or_equal_to: 0
  after_initialize do
    self.warranty_term ||= item.try(:warranty_term)
    self.defect_qty ||= 0
  end

  def deduct_spare_parts
    if (store_src = Store.spare_parts.first).present?
      # Deducting used spare parts
      self.store_item(store_src).dec(self.quantity)

      # Moving defected spare parts
      if (store_dst = Store.defect.first).present? and self.defect_qty > 0
        self.store_item(store_src).move_to(store_dst, self.defect_qty)
      end
    end
  end

end
