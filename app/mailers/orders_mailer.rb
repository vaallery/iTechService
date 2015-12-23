class OrdersMailer < ActionMailer::Base
  def notice(order_id)
    @order = Order.find order_id
    mail to: 'kolesnik@itech.pw, oleinikov@itech.pw', subject: t('mail.orders.new')
  end
end
