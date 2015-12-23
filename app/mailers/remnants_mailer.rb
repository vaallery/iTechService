class RemnantsMailer < ActionMailer::Base
  include ApplicationHelper

  def warning(product, store)
    @product = product
    @store = store
    mail to: 'kolesnik@itech.pw, popov@itech.pw, oleinikov@itech.pw, shamaev@itech.pw', subject: t('mail.remnants.warn_subject', product: @product.name)
  end

end