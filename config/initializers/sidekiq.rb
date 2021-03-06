Sidekiq.configure_server do |_|
  schedule_file = Rails.root.join('config/schedule.yml')

  if File.exists?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end
