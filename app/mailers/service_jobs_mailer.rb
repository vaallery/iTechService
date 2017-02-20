class ServiceJobsMailer < ApplicationMailer

  def done_notice(service_job_id)
    @service_job = ServiceJob.find service_job_id
    mail to: @service_job.email, subject: I18n.t('mail.service_jobs.done_notice.subject', device_type: @service_job.type_name)
  end
end