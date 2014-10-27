source 'https://rubygems.org'
#source 'http://gems.rubyforge.org'
ruby '2.1.3'
# gem 'nokogiri', '1.6.1'
gem 'rails', '3.2.19'
gem 'unicorn', '~> 4.6.2'
gem 'pg', '~> 0.14.1'
gem 'thin', '~> 1.5.0'
gem 'haml-rails', '~> 0.3.5'
gem 'jquery-rails', '~> 2.2.1'
gem 'simple_form', '~> 2.0.4'
gem 'json_builder', '~> 3.1.7'
gem 'devise', '~> 2.2.1'
gem 'cancan', '~> 1.6.8'
gem 'kaminari', '~> 0.14.1'
gem 'ancestry', '~> 1.3.0'
gem 'prawn', '~> 0.14'
gem 'carrierwave', '~> 0.10.0'#, '~> 0.8.0'
gem 'mini_magick', '~> 3.4'
gem 'ckeditor', '~> 3.7.3'
gem 'uuidtools', '~> 2.1.3'
gem 'exception_notification', '~> 2.6.1'#, git: 'git://github.com/alanjds/exception_notification.git'
gem 'private_pub', '~> 1.0.3'
gem 'twitter-bootstrap-rails', '~> 2.2.7'#, :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'seed_dumper', '~> 0.1.3'
gem 'json', '~> 1.7.7'
gem 'irwi', '~> 0.4.2', git: 'git://github.com/alno/irwi.git'
gem 'RedCloth', '~> 4.2.9'
gem 'roo', '~> 1.13.0'
gem 'paperclip', '~> 3.4.0'
gem 'barby', '~> 0.5.1'
gem 'acts_as_list', '~> 0.2.0'
gem 'delayed_job_active_record', '~> 0.4.4'
gem 'delayed_job_web', '~> 1.2.0'
gem 'whenever', '~> 0.8.4', require: false
gem 'foreman', '~> 0.63.0'
gem 'grape', '~> 0.6.1'
gem 'grape-entity', '~> 0.4.1'
gem 'figaro', '~> 1.0.0'
gem 'rmagick', '~> 2.13.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
  gem 'less-rails', '~> 2.4.2'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-colorpicker-rails', '~> 0.3.1', require: 'bootstrap-colorpicker-rails'#, :git => 'git://github.com/alessani/bootstrap-colorpicker-rails.git'
end

group :development do
  #gem 'debugger' unless ENV['RM_INFO']
  #gem 'debugger-xml'
  #gem 'debugger-linecache'
  gem 'capistrano', '~> 3.2'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler', '~> 1.1'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'stack_rescue'
  gem 'binding_of_caller'
  gem 'meta_request', '~> 0.2.8'
  gem 'mailcatcher'
  gem 'rails-erd'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'railroady'
  #gem 'faker'
  #gem 'ffaker'
end
