class DocumentMailer < ApplicationMailer
  include ApplicationHelper
  include FeaturesHelper

  def deduction_notification(deduction_act_id)
    @deduction_act = DeductionAct.find(deduction_act_id)
    mail to: recipients, subject: t('mail.document.deduction_notification')
  end

  private

  def recipients
    Setting.get_value 'emails_for_acts'
  end
end