class SalesReport < BaseReport

  def call
    result[:sales] = []
    sales_sum = 0
    sales_count = 0
    discounts_sum = 0
    sales = Sale.sold_at(period).posted.order('date asc')

    sales.selling.each do |sale|
      sale.sale_items.each do |sale_item|
        sale_item_sum = sale_item[:price] * sale_item[:quantity]

        payment_type = sale.payment_kinds.map do |payment_kind|
          I18n.t("payments.kinds.#{payment_kind}")
        end.join(', ')

        result[:sales] << {
          time: sale.date,
          product: sale_item.name,
          features: sale_item.features_s,
          quantity: sale_item.quantity,
          price: sale_item.price,
          sum: sale_item_sum,
          discount: sale_item.discount,
          payment_type: payment_type,
          client_id: sale.client_id,
          client: sale.client_short_name,
          user_id: sale.user_id,
          user: sale.user_short_name
        }

        sales_count = sales_count + sale_item.quantity
        sales_sum = sales_sum + sale_item_sum
        discounts_sum = discounts_sum + sale_item.discount
      end
    end

    result[:sales_count] = sales_count
    result[:sales_sum] = sales_sum
    result[:discounts_sum] = discounts_sum
    result
  end
end