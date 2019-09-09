# TODO: implement
class MarginReport < BaseReport

  def call
    result.deep_merge!({repair: {sum: 0, details: []}, service: {sum: 0, details: []}, sale: {sum: 0, details: []}, sum: 0})
    sales = Sale.posted.selling.sold_at(period).date_asc

    sales.find_each do |sale|
      sale.sale_items.find_each do |sale_item|
        if sale_item.is_repair?
          kind = :repair
        elsif sale_item.is_service?
          kind = :service
        else
          kind = :sale
        end
        details = []
        total_margin = 0
        if sale_item.is_repair?
          sale_item.device_task&.repair_tasks&.each do |repair_task|
            details << repair_task.as_json(only: [:id], methods: [:name, :price, :purchase_price, :margin])
                         .transform_keys(&:to_sym)
                         .merge(purchase_price: repair_task.parts_cost,
                                quantity: repair_task.repair_parts.count,
                                discount: '?')
            total_margin += repair_task.margin
          end
        else
          details.push sale_item.as_json(only: [:id], methods: [:name, :price, :quantity, :discount, :purchase_price, :margin]).transform_keys(&:to_sym)
          total_margin = sale_item.margin * sale_item.quantity
        end
        result[kind][:sum] = result[kind][:sum] + total_margin
        result[kind][:details] += details
        result[:sum] = result[:sum] + total_margin
      end
    end
    result
  end
end