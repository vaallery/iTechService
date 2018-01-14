# TODO: implement
class MarginReport < BaseReport

  def call
    result.deep_merge!({repair: {sum: 0, details: []}, service: {sum: 0, details: []}, sale: {sum: 0, details: []}, sum: 0})
    sales = Sale.posted.sold_at(period).date_asc

    sales.selling.find_each do |sale|
      sale.sale_items.find_each do |sale_item|
        if sale_item.is_repair?
          kind = :repair
        elsif sale_item.is_service?
          kind = :service
        else
          kind = :sale
        end
        details = []
        if sale_item.is_repair?
          if (repair_parts = sale.try(:service_job).try(:repair_parts)).present?
            repair_parts.each do |repair_part|
              details.push repair_part.as_json(only: [:id], methods: [:name, :purchase_price]).transform_keys(&:to_sym)
            end
          end
        else
          details.push sale_item.as_json(only: [:id], methods: [:name, :price, :quantity, :discount, :purchase_price, :margin]).transform_keys(&:to_sym)
        end
        result[kind][:details].concat details
        result[kind][:sum] = result[kind][:sum] + (sale_item.margin * sale_item.quantity)
        result[:sum] = result[:sum] + (sale_item.margin * sale_item.quantity)
      end
    end
    result
  end
end