ItechService::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false
  # config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Don't fallback to assets pipeline if a precompiled asset is missed
  #config.assets.compile = false
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5
  
  host = {
    vl: '192.168.0.1',
    kh: '192.168.4.200',
    sah: '192.168.9.180'
  }[(ENV['DEPARTMENT_CODE'] || 'vl').to_sym]
  config.action_mailer.default_url_options = { host: host }
  ActionMailer::Base.default from: 'iTechService <noreply@itechdevs.com>'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
      :address              => 'smtp.gmail.com',
      :port                 => 587,
      :domain               => 'itechdevs.com',
      :user_name            => 'noreply@itechdevs.com',
      :password             => '6Ra4yEho',
      :authentication       => 'plain',
      :enable_starttls_auto => true
  }

  config.action_mailer.perform_deliveries = true

  Paperclip.options[:command_path] = '/usr/local/bin'

end
