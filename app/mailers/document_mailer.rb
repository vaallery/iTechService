class DocumentMailer < ActionMailer::Base
  include ApplicationHelper
  include FeaturesHelper

  def deduction_notification(deduction_act)
    @deduction_act = deduction_act
    mail to: 'oleg@itechstore.ru', subject: t('mail.document.deduction_notification')
  end
end