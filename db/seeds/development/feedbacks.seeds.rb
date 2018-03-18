Service::Feedback.destroy_all

location = User.find_by(username: 'test')&.location

ServiceJob.located_at(location).newest.take(10).each do |job|
  Service::Feedback::MAX_DELAY_HOURS.each do |delay|
    created_at = delay.hours.ago
    feedback = Service::Feedback.create! service_job: job, details: Faker::Lorem.paragraph, created_at: created_at
    puts "Created feedback #{feedback}"
  end

  feedback = Service::Feedback.create! service_job: job, scheduled_on: Time.current
  puts "Created feedback #{feedback}"
end

job = ServiceJob.where.not(location: location).newest.first
feedback = Service::Feedback.create! service_job: job, scheduled_on: Time.current
puts "Created feedback #{feedback}"

job = ServiceJob.where(location: Location.archive).newest.first
feedback = Service::Feedback.create! service_job: job, scheduled_on: Time.current
puts "Created feedback #{feedback}"

job = ServiceJob.where(location: Location.done).newest.first
feedback = Service::Feedback.create! service_job: job, scheduled_on: Time.current
puts "Created feedback #{feedback}"

puts "Created #{Service::Feedback.count} feedbacks"
