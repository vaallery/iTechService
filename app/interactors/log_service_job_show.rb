class LogServiceJobShow
  include Interactor

  def call
    job = context.service_job
    user = context.user
    log = Logger.new 'log/service_jobs_show.log'
    log.info "Талон: #{job.ticket_number} (#{job.presentation}) [#{job.id}]. Пользователь: #{user.full_name} [#{user.id}]. Время: #{context.time}"
  end
end