class MovementMailer < ApplicationMailer
  include ApplicationHelper

  def notice(device)
    @device = device
    mail to: 'yuriy.popov@itechstore.ru', subject: t('mail.movement.subject', device: @device.presentation)
  end

end