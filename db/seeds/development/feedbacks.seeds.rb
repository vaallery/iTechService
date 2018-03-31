Service::Feedback.destroy_all

location = User.find_by(username: 'test')&.location
service_jobs = ServiceJob.located_at(location).newest

class << self
  def create_feedback(job, time, scheduled: false, log: nil)
    feedback = Service::Feedback.new service_job: job, created_at: time, log: log
    if scheduled
      feedback.scheduled_on = Time.current
    else
      feedback.details = Faker::Lorem.paragraph
    end
    feedback.save!
    puts "Created feedback #{feedback}"
  end

  def schedule_log(time, scheduled_on = Time.current)
    "[#{I18n.l(time, format: :long)}] Перенесено на #{I18n.l(scheduled_on, format: :long)}"
  end

  def postpone_log(time)
    "[#{I18n.l(time, format: :long)}] #{I18n.t('service.feedback.postponed')}"
  end
end

service_jobs.take(10).each do |job|
  feedback_time = 15.days.ago
  log = [
    "[#{I18n.l(job.created_at, format: :long)}] Запланировано на #{I18n.l(feedback_time, format: :long)}",
    postpone_log(feedback_time),
    postpone_log(1.hours.since(feedback_time)),
    schedule_log(2.hours.since(feedback_time), 12.days.ago)
  ].join('<br/>')
  create_feedback job, feedback_time, log: log

  feedback_time = 12.days.ago
  log = [
    postpone_log(feedback_time),
    schedule_log(1.hours.since(feedback_time), 7.days.ago)
  ].join('<br/>')
  create_feedback job, feedback_time, log: log

  feedback_time = 7.days.ago
  log = schedule_log(feedback_time)
  create_feedback job, feedback_time, log: log, scheduled: true
end

job = ServiceJob.where.not(location: location).newest.first
create_feedback job, scheduled: true

job = ServiceJob.where(location: Location.archive).newest.first
create_feedback job, scheduled: true

job = ServiceJob.where(location: Location.done).newest.first
create_feedback job, scheduled: true

puts "Created #{Service::Feedback.count} feedbacks"
