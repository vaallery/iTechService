class MarginReport < BaseReport

  def call
    result.deep_merge!({repair: {sum: 0, details: []}, service: {sum: 0, details: []}, sale: {sum: 0, details: []}, sum: 0})
    sales = Sale.posted.sold_at(period).order('date asc')

    sales.selling.each do |sale|
      sale.sale_items.each do |sale_item|
        if sale_item.is_repair?
          kind = :repair
          # if (repair_tasks = sale_item.device_task.try(:repair_tasks)).present?

          # end
        elsif sale_item.is_service
          kind = :service
        else
          kind = :sale
        end
        # details = []
        # if sale_item.is_repair?
        #   if (repair_parts = sale.try(:service_job).try(:repair_parts)).present?
        #     repair_parts.each do |repair_part|
        #       details << repair_part.as_json(methods: [:id, :name, :price])
        #     end
        #   end
        # else
        #   details << sale_item.as_json(methods: [:id, :name, :price, :quantity, :discount, :purchase_price, :margin])
        # end
        # result[kind][:details] = result[kind][:details] + details
        result[kind][:details] << sale_item.as_json(methods: [:id, :name, :price, :quantity, :discount, :purchase_price, :margin, :product_id])
        result[kind][:sum] = result[kind][:sum] + (sale_item.margin * sale_item.quantity)
        result[:sum] = result[:sum] + (sale_item.margin * sale_item.quantity)
      end
    end
    result
  end
end