class DeviceOrdersReport < BaseReport

  def call
    result[:orders] = []
    orders_count = 0
    Order.device.where(created_at: period).group(:object).sum(:quantity).each_pair do |key, val|
      result[:orders] << { name: key, quantity: val }
      orders_count = orders_count + val
    end
    result[:orders_count] = orders_count
    result
  end
end