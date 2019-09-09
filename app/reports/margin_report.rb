# TODO: implement
class MarginReport < BaseReport

  def call
    result.deep_merge!({
                         repair: {sum: 0, sum_last: 0, details: []},
                         service: {sum: 0, sum_last: 0, details: []},
                         sale: {sum: 0, sum_last: 0, details: []},
                         sum: 0,
                         sum_last: 0
                       })

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
        total_margin_last = 0
        if sale_item.is_repair?
          sale_item.device_task&.repair_tasks&.each do |repair_task|
            purchase_price_last = repair_task.repair_parts.to_a.sum(&:last_batch_price)
            margin_last = repair_task.price - purchase_price_last

            details << repair_task.as_json(only: [:id], methods: [:name, :price, :margin])
                         .transform_keys(&:to_sym)
                         .merge(purchase_price: repair_task.parts_cost,
                                purchase_price_last: purchase_price_last,
                                margin_last: margin_last,
                                quantity: repair_task.repair_parts.count,
                                discount: '?')
            total_margin += repair_task.margin
            total_margin_last += margin_last
          end
        else
          details.push sale_item.as_json(only: [:id], methods: [:name, :price, :quantity, :discount, :purchase_price, :margin]).transform_keys(&:to_sym)
          total_margin = sale_item.margin * sale_item.quantity
        end
        result[kind][:details] += details
        result[kind][:sum] += total_margin
        result[kind][:sum_last] += total_margin_last
        result[:sum] += total_margin
        result[:sum_last] += total_margin_last
      end
    end
    result
  end
end