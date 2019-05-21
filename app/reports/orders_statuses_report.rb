class OrdersStatusesReport < BaseReport
  def call
    Order.includes(:user).where(created_at: period).find_each do |order|
      user_name = order.user.full_name

      if result.has_key?(user_name)
        result[user_name][:total] += 1

        if result[user_name].has_key?(order.status)
          result[user_name][order.status] += 1
        else
          result[user_name].store(order.status, 1)
        end
      else
        result.store(user_name, {:total => 1, order.status => 1})
      end
    end
  end
end
