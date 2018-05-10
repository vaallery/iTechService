users = User.active.software

users.each do |user|
  10.times do
    task = Service::FreeTask.order('RANDOM()').first
    client = Client.order('RANDOM()').first
    performed_at = Faker::Time.backward(10, :day)
    Service::FreeJob.create! performed_at: performed_at, performer: user, task: task, client: client
  end
end
