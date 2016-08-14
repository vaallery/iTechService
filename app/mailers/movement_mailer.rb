class MovementMailer < ApplicationMailer
  include ApplicationHelper

  def notice(service_job)
    @service_job = service_job
    mail to: 'yuriy.popov@itechstore.ru', subject: t('mail.movement.subject', service_job: @service_job.presentation)
  end

end