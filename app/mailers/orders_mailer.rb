class OrdersMailer < ApplicationMailer
  def notice(order_id)
    @order = Order.find order_id
    mail to: Setting.emails_for_orders, subject: t('mail.orders.new')
  end
end
