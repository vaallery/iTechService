class DocumentMailer < ApplicationMailer
  include ApplicationHelper
  include FeaturesHelper

  def deduction_notification(deduction_act_id)
    @deduction_act = DeductionAct.find deduction_act_id
    mail to: 'oleg@itechstore.ru', subject: t('mail.document.deduction_notification')
  end
end