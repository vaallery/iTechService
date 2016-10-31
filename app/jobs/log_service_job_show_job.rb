class LogServiceJobShowJob < ActiveJob::Base
  queue_as :default

  def perform(service_job_id, user_id, time)
    service_job = ServiceJob.find service_job_id
    user = User.find user_id
    LogServiceJobShow.call service_job: service_job, user: user, time: time
  end
end