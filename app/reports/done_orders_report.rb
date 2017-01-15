class DoneOrdersReport < BaseReport

  def call
    result[:orders] = []
    done_orders = Order.done_at period
    done_orders.find_each do |order|
      result[:orders] << {order: order, done_at: order.done_at}
    end
    result[:done_orders_count] = done_orders.count
    result
  end
end