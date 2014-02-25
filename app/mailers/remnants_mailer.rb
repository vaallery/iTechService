class RemnantsMailer < ActionMailer::Base
  include ApplicationHelper

  def warning(product, store)
    @product = product
    @store = store
    mail to: 'yuriy.popov@itechstore.ru, vitali.kolesnik@itechstore.ru, oleg@itechstore.ru', subject: t('mail.remnants.warn_subject', product: @product.name)
  end

end