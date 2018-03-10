Service::Feedback.destroy_all

location = User.find_by(username: 'test')&.location

ServiceJob.pending.located_at(location).newest.take(10).each do |job|
  Service::Feedback::MAX_DELAY_HOURS.each do |delay|
    created_at = delay.hours.ago
    feedback = Service::Feedback.create! service_job: job, details: Faker::Lorem.paragraph, created_at: created_at
    puts "Created feedback #{feedback}"
  end

  feedback = Service::Feedback.create! service_job: job, scheduled_on: Time.current
  puts "Created feedback #{feedback}"
end

puts "Created #{Service::Feedback.count} feedbacks"
