source 'https://rubygems.org'
#source 'http://gems.rubyforge.org'

gem 'rails', '3.2.14'

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
gem 'prawn', '~> 0.12.0'
gem 'carrierwave', '~> 0.8.0'
gem 'mini_magick', '~> 3.4'
gem 'ckeditor', '~> 3.7.3'
gem 'uuidtools', '~> 2.1.3'
gem 'exception_notification', '~> 2.6.1'#, git: 'git://github.com/alanjds/exception_notification.git'
gem 'private_pub', '~> 1.0.3'
gem 'twitter-bootstrap-rails', '~> 2.2.7'#, :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'seed_dumper', '~> 0.1.3'
gem 'json', '1.7.7'
gem 'taps'
gem 'irwi', git: 'git://github.com/alno/irwi.git'
gem 'RedCloth'
gem 'roo'
gem 'paperclip', '3.4.0'
gem 'backup'
gem 'barby'
gem 'has_barcode'
gem 'acts_as_list'
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'whenever', require: false

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
  gem 'less-rails', '~> 2.2.6'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-colorpicker-rails', require: 'bootstrap-colorpicker-rails'#, :git => 'git://github.com/alessani/bootstrap-colorpicker-rails.git'
end

group :development do
  #gem 'debugger' unless ENV["RM_INFO"]
  #gem 'debugger-linecache'
  #gem 'debugger-pry', require: 'debugger/pry'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request', '0.2.1'
  gem 'capistrano-deploy', '~> 0.3.2'
  gem 'mailcatcher'
  gem 'linecache19'#, '>= 0.5.13', git: 'https://github.com/robmathews/linecache19-0.5.13.git'
  #gem 'linecache19', path: "/Users/v/projects/rails/_gems/linecache19-0.5.13"
  gem 'ruby-debug19'
  gem 'ruby-debug-base19x', '0.11.30.pre14', require: 'ruby-debug-base' #, path: '/Applications/RubyMine.app/rb/gems'
  gem 'ruby-debug-ide', '0.4.19', require: 'ruby-debug-ide' #, path: '/Applications/RubyMine.app/rb/gems'
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
  #gem 'faker'
  #gem 'ffaker'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'debugger'
