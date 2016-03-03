# Load the Rails application
require File.expand_path('../application', __FILE__)

# Initialize the Rails application
ItechService::Application.initialize!
ENV['RAILS_ENV'] ||= 'production'
