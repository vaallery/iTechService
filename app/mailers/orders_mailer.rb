class OrdersMailer < ActionMailer::Base
  def notice(order_id)
    @order = Order.find order_id
    mail to: 'kvn@itechdevs.com kolesnik@itech.pw', subject: t('mail.orders.new')
  end
end
