source 'https://rubygems.org'

gem 'rails', '4.2.5.2'
gem 'protected_attributes'
gem 'rails-observers'
# gem 'pg', '~> 0.14.1'
gem 'pg'
# gem 'haml-rails', '~> 0.3.5'
gem 'hamlit', '~> 2.2.0'
# gem 'hamlit-rails', '~> 0.1.0'
# gem 'slim-rails'
gem 'jquery-rails', '~> 4.1.1'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'simple_form', '~> 3.2.1'
# gem 'json_builder', '~> 3.1.7'
gem 'jbuilder', '~> 2.0'
gem 'devise', '~> 4.0.3'
gem 'devise_token_auth', '~> 0.1.37'

gem 'dry-validation', '~> 0.10.5'
gem 'trailblazer', '~> 1.0'
gem 'trailblazer-rails', '~> 0.4'
# gem 'trailblazer-rails', '~> 0.2.4'
gem 'reform-rails', '~> 0.1'
gem 'trailblazer-cells', '~> 0.0.3'
gem 'cells-rails', '~> 0.0.7'
gem 'cells-slim', '~> 0.0.5'
gem 'pundit', '~> 1.1.0'
# gem 'cancan', '~> 1.6.8'
gem 'cancancan', '~> 1.10'
gem 'kaminari', '~> 0.16.3'
gem 'ancestry', '~> 2.1.0'
gem 'prawn', '~> 2.1.0'
gem 'prawn-table', '~> 0.2.1'
gem 'carrierwave', '~> 0.11.2'#, '~> 0.8.0'
gem 'mini_magick', '~> 4.5.1'
gem 'ckeditor', '~> 4.1.6'
gem 'uuidtools', '~> 2.1.5'
gem 'interactor-rails', '~> 2.0.2'
gem 'exception_notification', '~> 4.1.4'#, git: 'git://github.com/alanjds/exception_notification.git'
gem 'private_pub', '~> 1.0.3'
gem 'thin', '~> 1.6.4'
gem 'twitter-bootstrap-rails', '~> 2.2.7'#, :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'seed_dumper', '~> 0.1.3'
gem 'irwi', '~> 0.5.0'
gem 'RedCloth', '~> 4.3.1'
gem 'roo', '~> 2.4.0'
gem 'paperclip', '~> 4.3.6'
gem 'barby', '~> 0.6.4'
gem 'acts_as_list', '~> 0.7.4'
gem 'delayed_job_active_record', '~> 4.1.1'
gem 'delayed_job_web', '~> 1.2.10'
gem 'whenever', '>= 0.8.4', :require => false
# gem 'foreman', '~> 0.63.0'
gem 'grape', '~> 0.6.1'
gem 'grape-entity', '~> 0.4.1'
gem 'rmagick', '~> 2.15.4'
gem 'zeroclipboard-rails'
gem 'sqlite3'
gem 'vpim'#, '~> 13.11.11'
gem 'puma'
gem 'draper', '~> 2.1.0'
gem 'seedbank'
gem 'daemons'
gem 'dotenv-rails'

gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby
gem 'less-rails', '~> 2.7.1'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-colorpicker-rails', '~> 0.3.1', :require => 'bootstrap-colorpicker-rails'
#, :git => 'git://github.com/alessani/bootstrap-colorpicker-rails.git'
# gem 'turbo-sprockets-rails3', '~> 0.3.14'

# gem 'nokogiri', github: 'sparklemotion/nokogiri'
gem 'nokogiri', '~> 1.6.7.2'

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  # gem 'capistrano-rbenv'
  gem 'capistrano-bundler', '~> 1.1'
  gem 'capistrano-passenger'
  gem 'capistrano-rails-collection'
  gem 'capistrano-faster-assets'
  # gem 'capistrano-rbenv-install'
  # gem 'capistrano-postgresql'
  gem 'capistrano-ssh-doctor'
  gem 'airbrussh', :require => false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'stack_rescue'
  gem 'binding_of_caller'
  gem 'meta_request', '~> 0.2.8'
  # gem 'mailcatcher'
  gem 'letter_opener'
  gem 'rails-erd'
end

group :development, :test do
  gem 'test-unit'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'railroady'
  gem 'minitest-rails'
  gem 'faker'#, '~> 1.3'
end

group :test do
  gem 'simplecov', '~> 0.12.0', :require => false

  gem 'minitest-reporters', '~> 1.0.0'
  gem 'minitest-rails-capybara'
  gem 'poltergeist'
  gem 'shoulda', '~> 3.5.0'
  gem 'shoulda-matchers'
  gem 'mocha', '~> 1.1.0'
  # # gem 'capybara-webkit'#, '~> 2.3'
  # # gem 'shoulda-matchers'
  # # gem 'selenium-webdriver'#, '~> 2.42'
  # gem 'database_cleaner'#, '~> 1.3'
  # gem 'launchy'#, '~> 2.4'
  # gem 'test_after_commit'
end

group :production do
  # gem 'unicorn', '~> 4.6.2'
  gem 'passenger', '>= 5.0.25', :require => 'phusion_passenger/rack_handler'
end