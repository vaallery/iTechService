class OrdersMailer < ApplicationMailer
  def notice(order_id)
    @order = Order.find order_id
    mail to: 'kolesnik@itech.pw, popov@itech.pw, oleinikov@itech.pw, shamaev@itech.pw', subject: t('mail.orders.new')
  end
end
