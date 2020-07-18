class DefectedSparePartsReport < BaseReport
  def call
    stores = Store.visible.defect_sp.in_department(department)
    movement_acts = MovementAct.posted.where(date: period, dst_store_id: stores)
    movement_items = MovementItem.where(movement_act_id: movement_acts)

    records = {}
    result[:total_qty] = result[:total_sum] = 0

    movement_items.find_each do |movement_item|
      if records.has_key?(movement_item.name)
        records[movement_item.name][:qty] += movement_item.quantity
      else
        data = {
          qty: movement_item.quantity,
          price: movement_item.purchase_price
        }
        records.store(movement_item.name, data)
      end

      result[:total_qty] += movement_item.quantity
      result[:total_sum] += movement_item.purchase_price * movement_item.quantity
    end

    result[:records] = records
    self
  end
end
