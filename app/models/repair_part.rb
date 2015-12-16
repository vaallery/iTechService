class RepairPart < ActiveRecord::Base
  belongs_to :repair_task, inverse_of: :repair_parts
  belongs_to :item
  delegate :name, :store_item, :code, :purchase_price, :product, to: :item, allow_nil: true
  delegate :store, to: :repair_task, allow_nil: true
  attr_accessible :quantity, :warranty_term, :defect_qty, :repair_task_id, :item_id
  validates_presence_of :item
  validates_numericality_of :warranty_term, only_integer: true, greater_than_or_equal_to: 0
  validate :remnants_presence
  after_update :move_defected, if: :defect_qty_changed?
  after_initialize do
    self.warranty_term ||= item.try(:warranty_term)
    self.defect_qty ||= 0
  end

  def deduct_spare_parts
    result = false
    if (store_src = Department.current.repair_store).present?
      result = self.store_item(store_src).dec(self.quantity)
    end
    !!result
  end

  def move_defected
    result = false
    if (store_src = self.store).present? and (store_dst = Department.current.defect_sp_store).present?
      qty_to_move = defect_qty - (defect_qty_was || 0)
      result = self.store_item(store_src).move_to(store_dst, qty_to_move)
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

  private

  def remnants_presence
    if store.present?
      defect_qty_diff = defect_qty - (defect_qty_was || 0)
      if store_item(store).quantity < (quantity + defect_qty_diff)
        errors[:base] << I18n.t('device_tasks.errors.insufficient_spare_parts', name: name)
      end
    end
  end

end
