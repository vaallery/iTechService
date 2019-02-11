class RemnantsMailer < ApplicationMailer
  include ApplicationHelper

  def warning(product_id, store_id)
    @product = Product.find product_id
    @store = Store.find store_id
    mail to: 'kolesnik@itech.pw, popov@itech.pw, oleinikov@itech.pw, shamaev@itech.pw', subject: t('mail.remnants.warn_subject', product: @product.name)
  end
end
