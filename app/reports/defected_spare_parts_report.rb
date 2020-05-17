class DefectedSparePartsReport < BaseReport
  def call
    stores = Store.defect_sp.in_department(department)
    movement_acts = MovementAct.posted.where(date: period, dst_store_id: stores)
    movement_items = MovementItem.where(movement_act_id: movement_acts)

    data = {}
    result[:total_qty] = 0
    movement_items.find_each do |movement_item|
      if data.has_key?(movement_item.name)
        data[movement_item.name] += movement_item.quantity
      else
        data.store(movement_item.name, movement_item.quantity)
      end

      result[:total_qty] += movement_item.quantity
    end

    result[:data] = data
    self
  end
end
